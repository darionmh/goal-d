import 'package:flutter/material.dart';
import 'package:goald/components/goal_card.dart';
import 'package:goald/event_emitter.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';
import 'package:provider/provider.dart';

class RecentlyCompleted extends StatefulWidget {
  EventEmitter collapseGoalsEvent;
  Function(BuildContext) scrollToContext;

  RecentlyCompleted({this.collapseGoalsEvent, this.scrollToContext});

  @override
  _RecentlyCompletedState createState() => _RecentlyCompletedState();
}

class _RecentlyCompletedState extends State<RecentlyCompleted> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  var goals = <Goal>[];
  var _unsub;

  @override
  void initState(){
    goals = _goalService.getRecentlyCompletedGoals();
    print('recent $goals');
    _unsub = _goalService.getStoreUpdateEvent().subscribe(() => setState(() => goals = _goalService.getRecentlyCompletedGoals()));

    super.initState();
  }

  void dispose() {
    _unsub();
    super.dispose();
  }

  List _buildRecentGoals(goals) {
    if (goals == null) return [];

    return goals
        .map((e) => GoalCard(
              goal: e,
              collapseEvent: widget.collapseGoalsEvent,
              onTap: (context) => widget.scrollToContext(context),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (goals == null || goals.isEmpty) return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Recently Completed',
              style: subheading,
            ),
          ),
          ..._buildRecentGoals(goals)
        ],
      ),
    );
  }
}
