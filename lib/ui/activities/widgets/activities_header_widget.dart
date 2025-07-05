import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/common/ui/custom_back_button.dart';
import 'package:architectures/ui/common/ui/home_button.dart';
import 'package:flutter/material.dart';

class ActivitiesHeader extends StatelessWidget {
  const ActivitiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.of(context).paddingScreenHorizontal,
          right: Dimens.of(context).paddingScreenHorizontal,
          top: Dimens.of(context).paddingScreenVertical,
          bottom: Dimens.paddingVertical,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBackButton(
              onTap: () {
                // Navigate to ResultsScreen and edit search
                Navigator.pop(context);
              },
            ),
            Text("Activities", style: Theme.of(context).textTheme.titleLarge),
            const HomeButton(),
          ],
        ),
      ),
    );
  }
}
