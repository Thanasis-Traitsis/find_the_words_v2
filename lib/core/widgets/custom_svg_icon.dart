import 'package:find_the_words/core/constants/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgIcon extends StatelessWidget {
  final CustomIcons icon;
  final Color color;
  final double? height;

  const CustomSvgIcon({
    super.key,
    required this.icon,
    required this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/${icon.fileName}.svg',
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: height,
    );
  }
}
