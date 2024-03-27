import 'package:flutter/material.dart';

import '../widgets/api_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const name = 'Home Screen';
  static const path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Request'),
      ),
      body: ApiForm(),
    );
  }
}
