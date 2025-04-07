import 'package:flutter/material.dart';
import 'package:subscription_tracker/pages/profile/screens/unauthorized/profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: const ProfileScreen());
  }
}
