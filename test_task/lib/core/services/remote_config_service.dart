import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
    : _remoteConfig = FirebaseRemoteConfig.instance; // singletone

  static FirebaseRemoteConfigService? _instance;
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  final FirebaseRemoteConfig _remoteConfig;

  String getString(String key) => _remoteConfig.getString(key);

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(
            minutes: 20,
          ), // The minimum amount of time that must pass before fetching new Remote Config
        ),
      );

      await _remoteConfig.setDefaults(<String, dynamic>{
        FirebaseRemoteConfigKeys.welcomeMessage: 'defaultdata',
      });
      await fetchAndActivate();
    } on Exception {
      print('Exception so  default values will be used');
    }
  }

  fetchAndActivate() async {
    try {
      bool updated = await _remoteConfig.fetchAndActivate();

      if (updated) {
        debugPrint('The config has been updated.');
      } else {
        debugPrint('The config is not updated..');
      }
    } on Exception catch (e) {
      print('Exception occurred: $e');
    }
    //await _remoteConfig.fetchAndActivate();
  }
}

class FirebaseRemoteConfigKeys {
  static const String welcomeMessage = 'wel_message';
}
