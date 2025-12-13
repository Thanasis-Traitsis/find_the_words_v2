import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/services/service_locator.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/words/domain/enums/sort_type.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortByButton extends StatelessWidget {
  const SortByButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<TotalWordsBloc, TotalWordsState>(
        builder: (context, state) {
          return PopupMenuButton<SortType>(
            offset: Offset(0, 44),
            color: context.colors.background,
            borderRadius: AppBorders.regularBorderRadius,
            clipBehavior: Clip.antiAlias,
            onSelected: (SortType value) {
              getIt<TotalWordsBloc>().add(UpdateSortEvent(value));
            },
            itemBuilder: (context) =>
                SortType.values.asMap().entries.map((entry) {
                  final sortType = entry.value;

                  return PopupMenuItem<SortType>(
                    padding: const EdgeInsets.all(AppSpacing.spacingM),
                    value: sortType,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spacingS,
                      ),
                      child: CustomText(
                        '• ${sortType.getLabel(context)}',
                        textType: state.sortType == sortType
                            ? CustomTextType.smallHeading
                            : CustomTextType.regularBody,
                      ),
                    ),
                  );
                }).toList(),
            child: TextButton(
              onPressed: null,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: AppBorders.regularBorderRadius,
                  ),
                ),
              ),
              child: Row(
                spacing: AppSpacing.spacingM,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    state.sortType.getLabel(context),
                    textType: CustomTextType.regularBody,
                  ),
                  CustomSvgIcon(
                    icon: CustomIcons.arrowsUpDown,
                    color: context.colors.text,
                    height: AppSizes.iconS,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
