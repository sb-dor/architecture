import 'package:architectures/models/activity.dart';
import 'package:architectures/ui/activities/controllers/activities_controller.dart';
import 'package:architectures/ui/common/themes/dimens.dart';
import 'package:flutter/material.dart';

class ActivitiesTitle extends StatelessWidget {
  const ActivitiesTitle({
    super.key,
    required this.activityTimeOfDay,
    required this.activitiesController,
  });

  final ActivitiesController activitiesController;
  final ActivityTimeOfDay activityTimeOfDay;

  @override
  Widget build(BuildContext context) {
    final list = switch (activityTimeOfDay) {
      ActivityTimeOfDay.daytime => activitiesController.daytimeActivities,
      ActivityTimeOfDay.evening => activitiesController.eveningActivities,
    };
    if (list.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: Dimens.of(context).edgeInsetsScreenHorizontal,
        child: Text(_label(context)),
      ),
    );
  }

  String _label(BuildContext context) => switch (activityTimeOfDay) {
    ActivityTimeOfDay.daytime => "Daytime",
    ActivityTimeOfDay.evening => "Evening",
  };
}
