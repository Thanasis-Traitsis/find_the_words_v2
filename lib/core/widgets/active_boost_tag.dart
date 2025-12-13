import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/core/utils/theme_extensions.dart';
import 'package:find_the_words/core/widgets/active_green_dot.dart';
import 'package:find_the_words/core/widgets/custom_svg_icon.dart';
import 'package:find_the_words/core/widgets/custom_text.dart';
import 'package:find_the_words/features/auth/account_boost_cubit/account_boost_cubit.dart';
import 'package:find_the_words/features/auth/data/models/account_boost_model.dart';
import 'package:find_the_words/features/auth/domain/entities/account_boost_entity.dart';
import 'package:find_the_words/features/store/presentation/helper/current_boost_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveBoostTag extends StatefulWidget {
  final bool withData;
  final bool isExpandable;

  const ActiveBoostTag({
    super.key,
    this.withData = false,
    this.isExpandable = false,
  });

  @override
  State<ActiveBoostTag> createState() => _ActiveBoostTagState();
}

class _ActiveBoostTagState extends State<ActiveBoostTag> {
  bool _isExpanded = true;

  @override
  void initState() {
    _isExpanded = !widget.isExpandable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBoostCubit, AccountBoostEntity?>(
      builder: (context, boost) {
        if (boost == null || !boost.isActive || boost.isExpired) {
          return const SizedBox.shrink();
        }

        if (widget.withData && boost.type == AccountBoostType.minutes) {
          return StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return _buildTag(context, boost);
            },
          );
        }

        return _buildTag(context, boost);
      },
    );
  }

  Widget _buildTag(BuildContext context, AccountBoostEntity boost) {
    return GestureDetector(
      onTap: () {
        if (widget.isExpandable) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacingM),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingL,
          vertical: AppSpacing.spacingM,
        ),
        decoration: BoxDecoration(
          color: context.colors.darkGreen,
          borderRadius: AppBorders.bigBorderRadius,
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.spacingS,
            children: [
              const ActiveGreenDot(),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.centerLeft,
                child: _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingS,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.spacingM,
                          children: [
                            CustomText(
                              context.translate.currentBoostTag,
                              textType: CustomTextType.smallTag,
                              isWhite: true,
                            ),
                            if (widget.withData) ...[
                              Container(color: context.colors.white, width: 1),
                              CustomText(
                                CurrentBoostHelper.getFormattedBoost(boost),
                                textType: CustomTextType.smallTag,
                                isWhite: true,
                              ),
                            ],
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (widget.isExpandable)
                CustomSvgIcon(
                  icon: CustomIcons.expand,
                  color: context.colors.white,
                  height: AppSizes.iconXXS,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
