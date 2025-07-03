import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';

import 'blur_filter.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key, this.blur = false});

  final bool blur;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (blur)
            ClipRect(
              child: BackdropFilter(
                filter: kBlurFilter,
                child: const SizedBox(height: 40.0, width: 40.0),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey1),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.transparent,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWidget()),
                  (_) => false,
                );
              },
              child: Center(
                child: Icon(
                  size: 24.0,
                  Icons.home_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
