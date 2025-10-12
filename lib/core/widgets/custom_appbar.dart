import 'package:find_the_words/config/theme/app_theme.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/services/navigation_service.dart';
import 'package:find_the_words/core/widgets/custom_icon_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/core/widgets/points_container.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? leadingIcon;
  final String? title;
  final Widget? suffixWidget;
  final String? suffixIcon;
  final VoidCallback? suffixOnTap;
  final Widget? userPoints;
  final bool? isHomePage;

  const CustomAppbar({
    super.key,
    this.leadingIcon,
    this.title,
    this.suffixWidget,
    this.suffixIcon,
    this.suffixOnTap,
  }) : userPoints = null,
       isHomePage = null;

  const CustomAppbar.withUserPoints({
    super.key,
    this.userPoints = const PointsContainer(),
    required this.isHomePage,
    this.suffixWidget,
    this.suffixIcon,
    this.suffixOnTap,
    this.leadingIcon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight,
      actionsPadding: EdgeInsets.only(right: AppSpacing.spacingL),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // CustomText('ds'),
            if (userPoints != null && isHomePage == true)
              userPoints!
            else ...[
              if (leadingIcon != null)
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.spacingS),
                  child: CustomIconButton(
                    onTap: () {
                      print("pop stage screen");
                      NavigationService.instance.pop();
                    },
                    icon: leadingIcon!,
                  ),
                ),
              if (title != null)
                Flexible(
                  fit: FlexFit.loose,
                  child: CustomText(
                    title!,
                    textType: CustomTextType.smallHeading,
                    maxLines: 2,
                  ),
                ),
            ],
          ],
        ),
      ),
      titleTextStyle: TextStyle(fontFamily: AppTheme.appFont),
      actions: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: isHomePage == false
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            spacing: AppSpacing.spacingM,
            children: [
              suffixWidget ?? SizedBox.shrink(),
              if (userPoints != null && isHomePage == false)
                userPoints!
              else ...[
                if (suffixIcon != null)
                  CustomIconButton(onTap: suffixOnTap!, icon: suffixIcon!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
