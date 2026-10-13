import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/text_strings.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: 8),
        Text(AppTexts.rememberMe.tr),
      ],
    );
  }
}