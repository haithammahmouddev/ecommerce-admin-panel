import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../styles/spacing_styles.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: SpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
              color: HelperFunctions.isDarkMode(context)
                  ? AppColors.black
                  : AppColors.white,
            ), // BoxDecoration
            child: child,
          ), // Container
        ), // SingleChildScrollView
      ), // SizedBox
    ); // Center
  }
}
