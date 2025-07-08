import 'package:architectures/models/activity.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:flutter/material.dart';

import 'activity_entry.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({
    super.key,
    required this.activitiesController,
    required this.activityTimeOfDay,
  });

  final ActivitiesController activitiesController;
  final ActivityTimeOfDay activityTimeOfDay;

  @override
  Widget build(BuildContext context) {
    final list = switch (activityTimeOfDay) {
      ActivityTimeOfDay.daytime => activitiesController.daytimeActivities,
      ActivityTimeOfDay.evening => activitiesController.eveningActivities,
    };
    return SliverPadding(
      padding: EdgeInsets.only(
        top: Dimens.paddingVertical,
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        bottom: Dimens.paddingVertical,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final activity = list[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < list.length - 1 ? 20 : 0),
            child: ActivityEntry(
              key: ValueKey("activities_item_${activity.ref}"),
              activity: activity,
              selected: activitiesController.selectedActivities.contains(activity.ref),
              onChanged: (value) {
                if (value!) {
                  activitiesController.addActivity(activity.ref);
                } else {
                  activitiesController.removeActivity(activity.ref);
                }
              },
            ),
          );
        }, childCount: list.length),
      ),
    );
  }
}