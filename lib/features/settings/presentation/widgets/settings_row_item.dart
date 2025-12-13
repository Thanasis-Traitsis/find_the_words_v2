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

  const SettingsRowItem({
    super.key,
    required this.name,
    required this.onTap,
    this.page,
    this.iconWidget,
    this.link,
  });

  SettingsRowItem.navigateToPage({
    super.key,
    required this.name,
    required this.page,
  }) : iconWidget = null,
       link = null,
       onTap = (() => page!.push());

  SettingsRowItem.navigateToWeb({
    super.key,
    required this.name,
    required this.link,
  }) : iconWidget = null,
       page = null,
       onTap = (() async {
         final Uri url = Uri.parse(link!);

         if (await canLaunchUrl(url)) {
           await launchUrl(url, mode: LaunchMode.inAppWebView);
         } else {
           // TODO: add snackbar
           debugPrint('Could not launch $link');
         }
       });

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
                color: context.colors.black,
              ),
            ),
          ),
          child: Row(
            spacing: AppSpacing.spacingL,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(name, textType: CustomTextType.bigBody),
              ),
              if (link != null)
                CustomSvgIcon(icon: CustomIcons.webLink, color: context.colors.black),
              if (page != null)
                CustomSvgIcon(icon: CustomIcons.arrowRight, color: context.colors.black),
              if (iconWidget != null) iconWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
