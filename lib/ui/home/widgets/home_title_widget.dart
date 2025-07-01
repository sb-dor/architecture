import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTitleWidget extends StatefulWidget {
  const HomeTitleWidget({super.key});

  @override
  State<HomeTitleWidget> createState() => _HomeTitleWidgetState();
}

class _HomeTitleWidgetState extends State<HomeTitleWidget> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = DependenciesScope.of(context).homeController;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _homeController,
      builder: (context, child) {
        final user = _homeController.user;
        if (user == null) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    user.picture,
                    width: Dimens.of(context).profilePictureSize,
                    height: Dimens.of(context).profilePictureSize,
                  ),
                ),
                // LogoutButton(
                //   viewModel: LogoutViewModel(
                //     authRepository: context.read(),
                //     itineraryConfigRepository: context.read(),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: Dimens.paddingVertical),
            _Title(text: user.name),
          ],
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => RadialGradient(
            center: Alignment.bottomLeft,
            radius: 2,
            colors: [Colors.purple.shade700, Colors.purple.shade400],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: GoogleFonts.rubik(textStyle: Theme.of(context).textTheme.headlineLarge),
      ),
    );
  }
}
