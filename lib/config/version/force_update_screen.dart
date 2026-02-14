import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/config/version/version_bloc/version_bloc.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/screens/custom_screen.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/widgets/custom_primary_button.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionBloc, VersionState>(
      builder: (context, state) {
        return CustomScreen(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/update_image.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  CustomText(
                    context.translate.forceUpdateTitle,
                    textType: CustomTextType.smallHeading,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: AppSpacing.spacingM,
                      bottom: AppSpacing.spacingXL,
                    ),
                    child: CustomText(
                      context.translate.forceUpdateSubtitle,
                      textType: CustomTextType.regularBody,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingXL),
                  if (state.storeUrl.isNotEmpty)
                    CustomPrimaryButton.large(
                      text: context.translate.forceUpdateButton,
                      onTap: () async {
                        final url = Uri.parse(state.storeUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      suffixIcon: CustomIcons.arrowRight,
                      fullWidth: true,
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
