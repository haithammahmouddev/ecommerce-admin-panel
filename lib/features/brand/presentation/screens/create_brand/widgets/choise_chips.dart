import 'package:flutter/material.dart';
import '../../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        avatar: HelperFunctions.getColor(text) != null
            ? TCircularContainer(width: 50, height: 50, backgroundColor: HelperFunctions.getColor(text)!)
            : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: HelperFunctions.getColor(text),
        labelStyle: TextStyle(color: selected ? AppColors.white : null),
        shape: HelperFunctions.getColor(text) != null ? const CircleBorder() : null,
        label: HelperFunctions.getColor(text) == null ? Text(text) : const SizedBox(),
        padding: HelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
        labelPadding: HelperFunctions.getColor(text) != null ? const EdgeInsets.all(0) : null,
      ), // ChoiceChip
    ); // Theme
  }
}
