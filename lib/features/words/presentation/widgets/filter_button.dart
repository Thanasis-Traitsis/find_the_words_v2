import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/previous_stage_words_service.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:find_the_words/features/words/presentation/widgets/filters_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotalWordsBloc, TotalWordsState>(
      builder: (context, state) {
        return Flexible(
          child: InkWell(
            borderRadius: AppBorders.bigBorderRadius,
            onTap: () async {
              final prevStageService = getIt<PreviousStageWordsService>();
              final List<String> prevWords = await prevStageService
                  .getPrevStageWords();

              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return FiltersBottomsheet(
                      filters: state.filters,
                      prevWords: prevWords,
                    );
                  },
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.spacingM),
              decoration: BoxDecoration(
                borderRadius: AppBorders.bigBorderRadius,
                border: Border.all(
                  width: AppBorders.smallBorderWidth,
                  color: context.colors.black,
                ),
              ),
              child: Row(
                spacing: AppSpacing.spacingM,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgIcon(
                    icon: CustomIcons.filter,
                    color: context.colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingS,
                      horizontal: AppSpacing.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: AppBorders.regularBorderRadius,
                    ),
                    child: CustomText(
                      state.filters.filtersCount.toString(),
                      textType: CustomTextType.regularBody,
                      isWhite: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
