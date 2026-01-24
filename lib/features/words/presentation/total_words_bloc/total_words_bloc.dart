import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/features/words/domain/enums/sort_type.dart';
import 'package:find_the_words/features/words/domain/models/word_filters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'total_words_event.dart';
part 'total_words_state.dart';

class TotalWordsBloc extends Bloc<TotalWordsEvent, TotalWordsState> {
  static const int _pageSize = 15;

  TotalWordsBloc() : super(TotalWordsState.empty()) {
    on<InitializeWordsEvent>(_onInitializeWords);
    on<LoadMoreWordsEvent>(_onLoadMoreWords);
    on<UpdateFiltersEvent>(_onUpdateFilters);
    on<UpdateSortEvent>(_onUpdateSort);
    on<SearchWordsEvent>(
      _onSearchWords,
      transformer: (events, mapper) {
        return restartable<SearchWordsEvent>().call(
          events.debounce(const Duration(milliseconds: 300)),
          mapper,
        );
      },
    );
    on<ResetFiltersEvent>(_onResetFilters);
  }

  void _onInitializeWords(
    InitializeWordsEvent event,
    Emitter<TotalWordsState> emit,
  ) async {
    emit(TotalWordsState.initial(event.wordsModel));
  }

  Future<void> _onLoadMoreWords(
    LoadMoreWordsEvent event,
    Emitter<TotalWordsState> emit,
  ) async {
    if (!event.resetListing) {
      if (state.isLoadingMore || !state.hasMoreData) return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final filteredWords = _getFilteredAndSortedWords();
    final startIndex = state.displayedWords.length;
    final endIndex = (startIndex + _pageSize).clamp(0, filteredWords.length);

    if (startIndex >= filteredWords.length) {
      emit(state.copyWith(isLoadingMore: false, hasMoreData: false));
      return;
    }

    final newWords = filteredWords.sublist(startIndex, endIndex);
    final updatedDisplayedWords = [...state.displayedWords, ...newWords];

    emit(
      state.copyWith(
        displayedWords: updatedDisplayedWords,
        isLoadingMore: false,
        isLoading: false,
        hasMoreData: endIndex < filteredWords.length,
      ),
    );
  }

  void _onUpdateFilters(
    UpdateFiltersEvent event,
    Emitter<TotalWordsState> emit,
  ) {
    emit(state.copyWith(filters: event.filters, displayedWords: []));
    add(LoadMoreWordsEvent(resetListing: true));
  }

  void _onUpdateSort(UpdateSortEvent event, Emitter<TotalWordsState> emit) {
    emit(state.copyWith(sortType: event.sortType, displayedWords: []));
    add(LoadMoreWordsEvent(resetListing: true));
  }

  void _onSearchWords(SearchWordsEvent event, Emitter<TotalWordsState> emit) {
    emit(state.copyWith(searchQuery: event.query, displayedWords: [], isLoading: true));
    add(LoadMoreWordsEvent(resetListing: true));
  }

  void _onResetFilters(ResetFiltersEvent event, Emitter<TotalWordsState> emit) {
    emit(
      state.copyWith(
        filters: WordFilters.initial(),
        displayedWords: [],
      ),
    );
    add(LoadMoreWordsEvent(resetListing: true));
  }

  List<MapEntry<String, dynamic>> _getFilteredAndSortedWords() {
    var words = state.wordsModel.words.entries.toList();

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      words = words.where((entry) {
        return entry.key.toLowerCase().contains(
          state.searchQuery.toLowerCase(),
        );
      }).toList();
    }

    // Apply filters
    if (state.filters.hasActiveFilters) {
      words = words.where((entry) {
        final word = entry.key;

        if (state.filters.isFilteringByLength) {
          if (word.length < state.filters.minWordLength ||
              word.length > state.filters.maxWordLength) {
            return false;
          }
        }

        if (state.filters.isFilteringByLetters) {
          if (!state.filters.selectedLetters.contains(word[0])) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    // Apply sorting
    switch (state.sortType) {
      case SortType.alphabeticalAZ:
        words.sort((a, b) => a.key.compareTo(b.key));
        break;
      case SortType.alphabeticalZA:
        words.sort((a, b) => b.key.compareTo(a.key));
        break;
      case SortType.smallWordsFirst:
        words.sort((a, b) => a.key.length.compareTo(b.key.length));
        break;
      case SortType.bigWordsFirst:
        words.sort((a, b) => b.key.length.compareTo(a.key.length));
        break;
    }

    return words;
  }
}
