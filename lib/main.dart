import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'background_service.dart';
import 'counting_down.dart';
import 'navigation.dart';
import 'settings.dart';
import 'history.dart';
import 'package:flutter/foundation.dart';
import 'package:timepiece/storage/configs.dart';

void envInitialize() {
  if (kDebugMode) {
    Logger.level = Level.debug;
    print("debug mode");
  } else if (kReleaseMode) {
    Logger.level = Level.info;
  } else {
    Logger.level = Level.debug;
  }
}





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  envInitialize();
  startBackgroundService();
  runApp(const NavigationBarApp());
}

