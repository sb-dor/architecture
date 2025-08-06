import 'package:architectures/models/activity.dart';
import 'package:architectures/ui/booking/controller/booking_controller.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'booking_header.dart';

class BookingBody extends StatelessWidget {
  const BookingBody({super.key, required this.bookingController});

  final BookingController bookingController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: bookingController,
      builder: (context, _) {
        final booking = bookingController.booking;
        if (booking == null) return const SizedBox();
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: BookingHeader(booking: booking)),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final activity = booking.activities[index];
                return _Activity(
                  activity: activity,
                  key: ValueKey<String>("booking_activity_${activity.ref}"),
                );
              }, childCount: booking.activities.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 200)),
          ],
        );
      },
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: activity.imageUrl, height: 80, width: 80),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  activity.timeOfDay.name.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  activity.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  activity.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
