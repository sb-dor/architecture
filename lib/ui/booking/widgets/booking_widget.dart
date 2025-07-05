import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/ui/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';

import 'booking_body_widget.dart';

class BookingWidget extends StatefulWidget {
  const BookingWidget({super.key, this.bookingId});

  final int? bookingId;

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  late final BookingController _bookingController;

  @override
  void initState() {
    super.initState();
    _bookingController = DependenciesScope.of(context).bookingController;
    if (widget.bookingId != null) {
      _bookingController.load(widget.bookingId!);
    } else {
      _bookingController.createBooking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, r) {
        // Back navigation always goes to home
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeWidget()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        floatingActionButton: ListenableBuilder(
          listenable: _bookingController,
          builder:
              (context, _) => FloatingActionButton.extended(
                // Workaround for https://github.com/flutter/flutter/issues/115358#issuecomment-2117157419
                heroTag: null,
                key: const ValueKey('share-button'),
                onPressed:
                    _bookingController.booking != null ? _bookingController.shareBooking : null,
                label: Text("Share Trip"),
                icon: const Icon(Icons.share_outlined),
              ),
        ),
        body: ListenableBuilder(
          // Listen to changes in both commands
          listenable: _bookingController,
          builder: (context, child) {
            // If either command is running, show progress indicator
            if (_bookingController.creatingBooking) {
              return const Center(child: CircularProgressIndicator());
            }
            return child!;
          },
          child: BookingBody(bookingController: _bookingController),
        ),
      ),
    );
  }
}
