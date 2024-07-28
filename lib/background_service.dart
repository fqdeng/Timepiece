import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timepiece/counting_down.dart';
import 'package:timepiece/notify/notification.dart';
import 'log.dart';

late FlutterBackgroundService service;

void startBackgroundService() {
  service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: false,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
}

late Timer _timer;

Duration _remainingDuration = Duration.zero;
Duration _settingTimeDuration = Duration.zero;
Duration _repeatNotifyDuration = Duration.zero;
bool _pause = false;
bool _timerStarted = false;
bool _stop = true;
DateTime _startDateTime = DateTime.now();

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  startNotificationService();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  startNotificationService();

  service.on("start").listen((event) {
    _remainingDuration = Duration(seconds: event!["duration"]);
    _settingTimeDuration = _remainingDuration;
    if (_stop) {
      _repeatNotifyDuration = Duration(seconds: event["repeat_duration"]);
      _startDateTime = DateTime.now();
    }
    if (_pause) {
      _startDateTime = DateTime.now();
    }
    if (!_timerStarted) {
      _startTimer(service);
      _timerStarted = true;
    }
    logger.d("background process has now started");
    _pause = false;
    _stop = false;
  });

  service.on("stop").listen((event) {
    _remainingDuration = Duration.zero;
    _settingTimeDuration = Duration.zero;
    logger.d("background process has now stopped");
    _pause = true;
    _stop = true;
  });

  service.on("pause").listen((event) {
    logger.d("background process has now paused");
    _pause = true;
  });
}

void _startTimer(ServiceInstance service) {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    // logger.d("service is successfully running");
    if (!_pause && !_stop) {
      // use system time to calculate the remaining time
      DateTime now = DateTime.now();
      int different = (now.millisecondsSinceEpoch -
              _startDateTime.millisecondsSinceEpoch) ~/
          1000;
      _remainingDuration = _settingTimeDuration - Duration(seconds: different);
      var alreadyUsedTime = _settingTimeDuration - _remainingDuration;
      if (alreadyUsedTime.inSeconds != 0) {
        if (alreadyUsedTime.inSeconds % _repeatNotifyDuration.inSeconds == 0) {
          logger.d("send clock notification");
          showNotification("Clock", "Time is up");
        }
      }
      if (_remainingDuration.isNegative) {
        _remainingDuration = Duration.zero;
      }
    }
    service.invoke('update', {
      "duration": _remainingDuration.inSeconds,
      "pause": _pause,
      "stop": _stop
    });
  });
}
