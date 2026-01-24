part of 'total_words_bloc.dart';

class TotalWordsState extends Equatable {
  final WordsModel wordsModel;
  final WordFilters filters;
  final SortType sortType;
  final String searchQuery;
  final List<MapEntry<String, dynamic>> displayedWords;
  final bool isLoadingMore;
  final bool hasMoreData;
  final bool isLoading;

  const TotalWordsState({
    required this.wordsModel,
    required this.filters,
    required this.sortType,
    required this.searchQuery,
    required this.displayedWords,
    required this.isLoadingMore,
    required this.hasMoreData,
    required this.isLoading,
  });

  TotalWordsState.empty()
    : wordsModel = WordsModel(words: {}),
      filters = WordFilters.initial(),
      sortType = SortType.alphabeticalAZ,
      searchQuery = '',
      displayedWords = const [],
      isLoadingMore = false,
      hasMoreData = false,
      isLoading = false;

  factory TotalWordsState.initial(WordsModel wordsModel) {
    final allWords = wordsModel.words.entries.toList();
    allWords.sort((a, b) => a.key.compareTo(b.key));
    
    final initialWords = allWords.take(15).toList();

    return TotalWordsState(
      wordsModel: wordsModel,
      filters: WordFilters.initial(),
      sortType: SortType.alphabeticalAZ,
      searchQuery: '',
      displayedWords: initialWords,
      isLoadingMore: false,
      hasMoreData: allWords.length > 15,
      isLoading: false,
    );
  }

  TotalWordsState copyWith({
    WordsModel? wordsModel,
    WordFilters? filters,
    SortType? sortType,
    String? searchQuery,
    List<MapEntry<String, dynamic>>? displayedWords,
    bool? isLoadingMore,
    bool? hasMoreData,
    bool? isLoading,
  }) {
    return TotalWordsState(
      wordsModel: wordsModel ?? this.wordsModel,
      filters: filters ?? this.filters,
      sortType: sortType ?? this.sortType,
      searchQuery: searchQuery ?? this.searchQuery,
      displayedWords: displayedWords ?? this.displayedWords,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [
    wordsModel,
    filters,
    sortType,
    searchQuery,
    displayedWords,
    isLoadingMore,
    hasMoreData,
    isLoading
  ];
}
