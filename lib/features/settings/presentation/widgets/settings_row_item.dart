import 'package:find_the_words/config/routes/app_pages.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsRowItem extends StatelessWidget {
  final String name;
  final AppPages? page;
  final VoidCallback onTap;
  final Widget? iconWidget;
  final String? link;
  final bool isLogout;
  final bool isDelete;

  const SettingsRowItem({
    super.key,
    required this.name,
    required this.onTap,
    this.page,
    this.iconWidget,
    this.link,
    this.isLogout = false,
    this.isDelete = false,
  });

  SettingsRowItem.navigateToPage({
    super.key,
    required this.name,
    required this.page,
  }) : iconWidget = null,
       link = null,
       isLogout = false,
       isDelete = false,
       onTap = (() => page!.push());

  SettingsRowItem.navigateToWeb({
    super.key,
    required this.name,
    required this.link,
  }) : iconWidget = null,
       page = null,
       isLogout = false,
       isDelete = false,
       onTap = (() async {
         final Uri url = Uri.parse(link!);

         if (await canLaunchUrl(url)) {
           await launchUrl(url, mode: LaunchMode.inAppWebView);
         } else {
           // TODO: add snackbar
           debugPrint('Could not launch $link');
         }
       });

  const SettingsRowItem.logout({
    super.key,
    required this.name,
    required this.onTap,
  }) : iconWidget = null,
       page = null,
       link = null,
       isDelete = false,
       isLogout = true;

  const SettingsRowItem.delete({
    super.key,
    required this.name,
    required this.onTap,
  }) : iconWidget = null,
       page = null,
       link = null,
       isDelete = true,
       isLogout = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingL),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: AppBorders.smallBorderWidth,
                color: isLogout || isDelete
                    ? context.colors.error
                    : context.colors.black,
              ),
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingL,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  name,
                  textStyle: TextStyle(
                    fontSize: CustomTextType.bigBody.fontSize,
                    fontWeight: CustomTextType.bigBody.fontWeight,
                    height: 1,
                    leadingDistribution: TextLeadingDistribution.even,
                    color: isLogout || isDelete
                        ? context.colors.error
                        : context.colors.text,
                  ),
                ),
              ),
              if (link != null)
                CustomSvgIcon(
                  icon: CustomIcons.webLink,
                  color: context.colors.black,
                ),
              if (page != null)
                CustomSvgIcon(
                  icon: CustomIcons.arrowRight,
                  color: context.colors.black,
                ),
              if (isLogout)
                CustomSvgIcon(
                  icon: CustomIcons.logout,
                  color: context.colors.error,
                ),
              if (isDelete)
                CustomSvgIcon(
                  icon: CustomIcons.delete,
                  color: context.colors.error,
                ),
              if (iconWidget != null) iconWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
