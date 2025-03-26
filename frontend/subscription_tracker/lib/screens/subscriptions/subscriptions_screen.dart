import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подписки')),
      body: const Center(
        child: Text('Список ваших подписок', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
