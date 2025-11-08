part of 'total_words_bloc.dart';

sealed class TotalWordsEvent extends Equatable {
  const TotalWordsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeWordsEvent extends TotalWordsEvent {
  final WordsModel wordsModel;

  const InitializeWordsEvent(this.wordsModel);

  @override
  List<Object?> get props => [wordsModel];
}

class LoadMoreWordsEvent extends TotalWordsEvent {
  final bool resetListing;

  const LoadMoreWordsEvent({this.resetListing = false});
}

class UpdateFiltersEvent extends TotalWordsEvent {
  final WordFilters filters;

  const UpdateFiltersEvent(this.filters);

  @override
  List<Object?> get props => [filters];
}

class UpdateSortEvent extends TotalWordsEvent {
  final SortType sortType;

  const UpdateSortEvent(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

class SearchWordsEvent extends TotalWordsEvent {
  final String query;

  const SearchWordsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ResetFiltersEvent extends TotalWordsEvent {}
