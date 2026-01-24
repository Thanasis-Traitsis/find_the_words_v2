import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/models/words_model.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/screens/dismiss_keyboard_screen.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/big_heading.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:find_the_words/features/words/presentation/widgets/filter_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/filters_chips_container.dart';
import 'package:find_the_words/features/words/presentation/widgets/search_textfield.dart';
import 'package:find_the_words/features/words/presentation/widgets/sort_by_button.dart';
import 'package:find_the_words/features/words/presentation/widgets/word_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalWordsScreen extends StatelessWidget {
  final WordsModel wordsModel;

  const TotalWordsScreen({super.key, required this.wordsModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<TotalWordsBloc>()..add(InitializeWordsEvent(wordsModel)),
      child: const _TotalWordsView(),
    );
  }
}

class _TotalWordsView extends StatefulWidget {
  const _TotalWordsView();

  @override
  State<_TotalWordsView> createState() => _TotalWordsViewState();
}

class _TotalWordsViewState extends State<_TotalWordsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getIt<TotalWordsBloc>().add(LoadMoreWordsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScreen(
      child: BlocBuilder<TotalWordsBloc, TotalWordsState>(
        builder: (context, state) {
          return CustomScreen(
            loadingScreen: state.isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingL,
              ),
              child: PopScope(
                canPop: true,
                onPopInvokedWithResult: (didPop, result) {
                  if (state.filters.hasActiveFilters) {
                    getIt<TotalWordsBloc>().add(ResetFiltersEvent());
                  }
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: BigHeading(
                        pageTitle: context.translate.wordsScreenName,
                        onBackButtonPressed: () {
                          NavigationService.instance.pop();
                        },
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.spacingM,
                      ),
                      sliver: SliverToBoxAdapter(child: SearchTextfield()),
                    ),
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: context.colors.background,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      titleSpacing: 0,
                      title: Row(
                        spacing: AppSpacing.spacingM,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const FilterButton(), const SortByButton()],
                      ),
                    ),
                    const SliverToBoxAdapter(child: FiltersChipsContainer()),
                    if (state.displayedWords.isEmpty && !state.isLoadingMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.spacingXL),
                          child: Center(
                            child: CustomText(
                              context.translate.totalWordsEmptyResult,
                              textType: CustomTextType.regularBody,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingM,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: state.displayedWords.length,
                            (context, index) {
                              final entry = state.displayedWords[index];
                              return Container(
                                margin: index == 0
                                    ? null
                                    : const EdgeInsets.only(
                                        top: AppSpacing.spacingL,
                                      ),
                                child: WordRowItem(
                                  word: entry.key,
                                  meanings: entry.value,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.spacingL),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    // if (!state.hasMoreData && state.displayedWords.isNotEmpty)
                    //   SliverToBoxAdapter(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(AppSpacing.spacingL),
                    //       child: Center(
                    //         child: CustomText(
                    //           'No more words to load',
                    //           textType: CustomTextType.regularBody,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
