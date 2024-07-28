import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timepiece/config/duration_config.dart';
import 'package:timepiece/domain/history.entity.dart';
import 'package:timepiece/event_bus.dart';
import 'package:timepiece/config/timer_config.dart';

import 'package:timepiece/count_down_timer.dart';
import 'package:timepiece/util.dart';

import 'background_service.dart';
import 'log.dart';

class CountDown extends StatefulWidget {
  const CountDown({super.key});

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  var _duration = getTime();
  bool _timerRunningFlag = false;
  bool _stop = false;
  late StreamSubscription<TimerConfig> _timerConfigSub;

  @override
  void initState() {
    super.initState();
    _timerConfigSub = eventBus.on<TimerConfig>().listen((timerConfig){

    });

    service.on('update').listen((onData) {
      var duration = Duration(seconds: onData?['duration']);
      // logger.d('Data from the background service seconds: ${duration.inSeconds}');
      if (mounted) {
        setState(() {
          _duration = duration;
          _timerRunningFlag = !onData?['pause'];
          _stop = onData?['stop'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timerConfigSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return TimerCountdown(
      format: CountDownTimerFormat.minutesSeconds,
      timerRunningFlag: _timerRunningFlag,
      timeTextStyle: const TextStyle(
        fontSize: 40,
        color: Colors.black87,
      ),
      duration: _duration,
      onEnd: () {
        logger.d('Timer ended');
      },
      onTick: (duration) {},
      onStart: () {
        logger.d('Timer started');
        if (_duration == Duration.zero || _stop) {
          _duration = getTime();
        }
        service.invoke('start', {'duration': _duration.inSeconds, 'repeat_duration': getDuration().inSeconds});
        eventBus.fire(
            HistoryItem(HistoryItemEnum.start, formatDateTime(DateTime.now())));
      },
      onPause: () {
        logger.d('Timer paused');
        service.invoke('pause');
        eventBus.fire(
            HistoryItem(HistoryItemEnum.pause, formatDateTime(DateTime.now())));
      },
      onStop: () {
        logger.d('Timer stopped');
        _stop = true;
        service.invoke('stop');
        eventBus.fire(
            HistoryItem(HistoryItemEnum.stop, formatDateTime(DateTime.now())));
      },
    );
  }
}
