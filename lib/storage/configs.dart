import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timepiece/history.dart';

import '../domain/history.entity.dart';
import '../config/timer_config.dart';
import '../config/duration_config.dart';

const key = 'history';

saveHistory(List<HistoryItem> items) async {
  final manager = await SharedPreferences.getInstance();
  List<String> histories = items.map((e) => jsonEncode(e.toJson())).toList();
  manager.setStringList(key, histories);
}

readHistories() async {
  final manager = await SharedPreferences.getInstance();
  final histories = manager.getStringList(key);
  if (histories == null) {
    return null;
  }
  return histories
      .map((item) => HistoryItem.fromJson(jsonDecode(item)))
      .toList();
}

saveTimeConfig(TimerEnum timerEnum) async {
  final manager = await SharedPreferences.getInstance();
  manager.setInt('timer', timerEnum.index);
}

getTimeConfig() async {
  final manager = await SharedPreferences.getInstance();
  final timer = manager.getInt('timer');
  if (timer == null) {
    return TimerEnum.minutes_30;
  }
  return TimerEnum.values[timer];
}

saveDurationConfig(DurationEnum durationEnum) async {
  final manager = await SharedPreferences.getInstance();
  manager.setInt('duration', durationEnum.index);
}

getDurationConfig() async {
  final manager = await SharedPreferences.getInstance();
  final duration = manager.getInt('duration');
  if (duration == null) {
    return DurationEnum.minutes_10;
  }
  return DurationEnum.values[duration];
}
