import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_bloc.dart';
import 'package:subscription_tracker/models/ui_color_bloc/ui_color_state.dart';
import 'package:subscription_tracker/widgets/navbar.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';
import 'pages/subscriptions/subscriptions_page.dart';
import 'pages/statistics/statistics_page.dart';
import 'pages/profile/profile_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  final _pageController = PageController(initialPage: 0);

  final _pages = <Widget>[
    SubscriptionsPage(),

    const StatisticsPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIColorBloc, UIColorState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Subscription Tracker',

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: BlocProvider.of<UIColorBloc>(context).state.color,
              dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
            ),
            textTheme: textTheme,
          ),

          home: Scaffold(
            backgroundColor: Colors.white,

            body: SafeArea(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),

                children: _pages,
              ),
            ),

            bottomNavigationBar: SafeArea(
              maintainBottomViewPadding: true,

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
      },
    );
  }
}
