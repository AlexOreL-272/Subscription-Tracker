import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_bloc.dart';
import 'package:subscription_tracker/models/user_bloc/user_state.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/profile_screen.dart'
    as unauthorized;
import 'package:subscription_tracker/pages/profile/screens/authorized/profile_screen.dart'
    as authorized;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          switch (state.authStatus) {
            case AuthStatus.unauthorized:
              return const unauthorized.ProfileScreen();
            case AuthStatus.authorized:
              return const authorized.ProfileScreen();
            default:
              return const unauthorized.ProfileScreen();
          }
        },
      ),
    );
  }
}
