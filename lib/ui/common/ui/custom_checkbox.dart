import 'package:architectures/ui/common/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 24,
      onTap: () => onChanged(!value),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey3),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color:
              value
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          child: SizedBox(
            width: 24,
            height: 24,
            child: Visibility(
              visible: value,
              child: Icon(
                Icons.check,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
