import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/logout/controllers/logout_controller.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  late final LogoutController _logoutController;

  @override
  void initState() {
    super.initState();
    _logoutController = DependenciesScope.of(context).logoutController;
  }

  void _onLogoutError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error while trying to logout"),
        action: SnackBarAction(
          label: "Try again",
          onPressed: () {
            _logoutController.logout(onLogoutError: _onLogoutError);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: InkResponse(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            _logoutController.logout(onLogoutError: _onLogoutError);
          },
          child: Center(
            child: Icon(size: 24.0, Icons.logout, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
