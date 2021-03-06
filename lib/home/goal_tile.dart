import 'package:flutter/material.dart';
import 'package:goald/home/milestone_list.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/models/milestone.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/goal_service.dart';

class GoalTile extends StatefulWidget {
  final Goal goal;

  const GoalTile({Key key, this.goal}) : super(key: key);

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();

  List<Widget> _buildChildren() {
    final children = <Widget>[];
    children.add(Text(widget.goal.title));
    if (widget.goal.goal != '') children.add(Text(widget.goal.goal));
    if (widget.goal.milestones.length > 0)
      children.add(MilestoneList(
        milestones: widget.goal.milestones,
        onUpdate: (milestone) {
          final i = widget.goal.milestones
              .indexWhere((Milestone element) => element.id == milestone.id);

          if (i >= 0) widget.goal.milestones[i] = milestone;

          _goalService.update(widget.goal);
        },
      ));
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete goal?"),
                actions: [
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                      child: Text('Delete'),
                      onPressed: () {
                        _goalService.delete(widget.goal);
                        Navigator.of(context).pop();
                      })
                ],
              );
            }),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Container(
                child: Icon(widget.goal.complete
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked),
                padding: EdgeInsets.all(16),
              ),
              onTap: () => setState(() {
                widget.goal.complete = !widget.goal.complete;
                _goalService.update(widget.goal);
              }),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildChildren(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              child: Text(widget.goal.endDate),
            ),
          ],
        ),
      ),
    );
  }
}
