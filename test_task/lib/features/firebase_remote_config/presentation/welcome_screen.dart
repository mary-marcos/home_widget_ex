import 'package:flutter/material.dart';
import 'package:test_task/core/services/remote_config_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfigService();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage),
          textAlign: TextAlign.center,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await remoteConfig.fetchAndActivate();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
