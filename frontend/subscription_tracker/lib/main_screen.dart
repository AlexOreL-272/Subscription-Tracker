import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/navbar.dart';
import 'screens/subscriptions/subscriptions_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'screens/profile/profile_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  final _pageController = PageController();

  final _screens = <Widget>[
    SubscriptionsScreen(),

    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Tracker',
      theme: ThemeData(
        // textTheme:
      ),

      home: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _screens,
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: NavBar(
              onTapped: (index) {
                if (_currentIndex == index) return;

                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
