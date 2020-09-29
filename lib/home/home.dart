import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goald/add/add_goal.dart';
import 'package:goald/home/dashboard.dart';
import 'package:goald/home/recent.dart';
import 'package:goald/home/upcoming.dart';
import 'package:goald/models/goal.dart';
import 'package:goald/navigation.dart';
import 'package:goald/service-locator.dart';
import 'package:goald/services/auth_service.dart';
import 'package:goald/services/goal_service.dart';
import 'package:goald/styles.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AbstractGoalService _goalService = locator<AbstractGoalService>();
  AbstractAuthService _authService = locator<AbstractAuthService>();

  var _currentIndex = 0;

  Widget home;

  @override
  void dispose() async {
    super.dispose();
    // await _authService.signOut();
  }

  Widget _buildHome(User user) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 25, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: accent_text,
              ),
              Text(user.displayName, style: heading),
            ],
          ),
        ),
        Dashboard(),
        StreamProvider<List<Goal>>(
          create: (_) => _goalService.upcomingGoals(),
          child: Upcoming(
            onClick: () => setState(() => _currentIndex = 1),
          ),
        ),
        // RecentlyCompleted(),
      ],
    );
  }

  Widget _getCurrentPage(User user) {
    switch (_currentIndex) {
      case 0:
        return _buildHome(user);
      case 2:
        return AddGoal(
          onFinish: () => setState(() => _currentIndex = 0),
        );
    }

    return Center(
      child: Text('Not Implemented'),
    );
  }

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);

    return Scaffold(
      body: Container(
        child: _getCurrentPage(user),
        margin: EdgeInsets.only(left: 25, right: 25),
      ),
      bottomNavigationBar: NavigationBar(
        currentIndex: _currentIndex,
        items: [
          NavigationItem(icon: Icon(Icons.home)),
          NavigationItem(icon: Icon(Icons.list)),
          NavigationItem(icon: Icon(Icons.add_circle_outline)),
          NavigationItem(icon: Icon(Icons.person_outline)),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
