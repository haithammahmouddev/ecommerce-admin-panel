import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AnimationLoaderWidget extends StatelessWidget {
  const AnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
    this.style,
    this.height,
    this.width,
  });

  final String text;
  final TextStyle? style;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final double? height;
  final double? width;

  bool get _isLottieFile {
    final lower = animation.toLowerCase();
    return lower.endsWith('.json') || lower.endsWith('.zip');
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? MediaQuery.of(context).size.height * 0.5;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isLottieFile
              ? Lottie.asset(
            animation,
            height: resolvedHeight,
            width: width,
          )
              : Image.asset(
            animation,
            height: resolvedHeight,
            width: width,
          ),
          const SizedBox(height: Sizes.defaultSpace),
          Text(
            text,
            style: style ?? Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.defaultSpace),
          showAction
              ? SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(backgroundColor: AppColors.darkContainer),
              child: Text(
                actionText!,
                style: Theme.of(context).textTheme.bodyMedium!.apply(color: AppColors.light),
              ),
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}