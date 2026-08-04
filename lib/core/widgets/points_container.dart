import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/points/cubit/points_cubit.dart';
import 'package:find_the_words/features/store/presentation/screens/store_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsContainer extends StatelessWidget {
  final bool withVoidCallback;

  const PointsContainer({super.key, this.withVoidCallback = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: withVoidCallback
          ? () {
              Future.delayed(const Duration(milliseconds: 350), () {
                if (!context.mounted) return;
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return const StoreBottomsheet();
                  },
                );
              });
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacingM),
        decoration: BoxDecoration(
          color: context.colors.lightPink,
          border: Border.all(
            width: AppBorders.smallBorderWidth,
            color: context.colors.darkPink,
          ),
          borderRadius: AppBorders.regularBorderRadius,
        ),
        child: Row(
          spacing: AppSpacing.spacingM,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSvgIcon(
              icon: CustomIcons.star,
              color: context.colors.secondary,
              height: AppSizes.iconS,
            ),
            BlocBuilder<PointsCubit, int>(
              builder: (context, points) {
                return CustomText(
                  points.toString(),
                  textStyle: TextStyle(
                    fontFamily: AppTheme.highlighFont,
                    fontSize: CustomTextType.regularBody.fontSize,
                    fontWeight: FontWeight.bold,
                    color: context.colors.darkPink,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
