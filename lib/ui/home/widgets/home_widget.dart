import 'package:architectures/models/booking_summary.dart';
import 'package:architectures/runner/widgets/dependencies_scope.dart';
import 'package:architectures/ui/common/themes/colors.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:architectures/ui/home/controller/home_controller.dart';
import 'package:architectures/utils/date_format_start_end.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = DependenciesScope.of(context).homeController;
    _homeController.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _homeController,
          builder: (context, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(),
                SliverList.separated(
                  itemCount: _homeController.bookingSummary.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _Booking(
                      booking: _homeController.bookingSummary[index],
                      onTap: () {},
                      confirmDismiss: (DismissDirection direction) async {
                        await _homeController.deleteBooking(
                          (_homeController.bookingSummary[index].id),
                        );
                        return true;
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Booking extends StatelessWidget {
  const _Booking({required this.booking, required this.onTap, required this.confirmDismiss});

  final BookingSummary booking;
  final GestureTapCallback onTap;
  final ConfirmDismissCallback confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(booking.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: confirmDismiss,
      background: Container(
        color: AppColors.grey1,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: Dimens.paddingHorizontal),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
            vertical: Dimens.paddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking.name, style: Theme.of(context).textTheme.titleLarge),
              Text(
                dateFormatStartEnd(DateTimeRange(start: booking.startDate, end: booking.endDate)),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
