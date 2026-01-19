import 'package:find_the_words/config/connectivity/connectivity_cubit/connectivity_cubit.dart';
import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final CustomIcons social;
  final bool requiresInternet;

  const CustomSocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    required this.social,
    this.requiresInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    if (requiresInternet) {
      return BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          final hasInternet = state is ConnectivityOnline;
          final isButtonDisabled = isDisabled || !hasInternet;

          return _buildButton(
            context,
            isButtonDisabled: isButtonDisabled,
            showOfflineIndicator: !hasInternet,
          );
        },
      );
    }

    return _buildButton(context, isButtonDisabled: isDisabled);
  }

  Widget _buildButton(
    BuildContext context, {
    required bool isButtonDisabled,
    bool showOfflineIndicator = false,
  }) {
    return OutlinedButton(
      onPressed: isButtonDisabled ? null : onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingXL,
            vertical: AppSpacing.spacingL,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppBorders.regularBorderRadius),
        ),
      ),
      child: Opacity(
        opacity: isButtonDisabled ? 0.7 : 1.0,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            spacing: AppSpacing.spacingM,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.iconM,
                height: AppSizes.iconM,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/${social.fileName}.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: CustomText(
                  text,
                  textType: CustomTextType.smallHeading,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
