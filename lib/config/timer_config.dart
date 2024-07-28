import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../storage/configs.dart';

TimerEnum? _timer = TimerEnum.minutes_30;

Duration getTime() {
  return _convertToMinutes(_timer!);
}

enum TimerEnum { minutes_30, minutes_60, minutes_90, minutes_120 }

Duration _convertToMinutes(TimerEnum timer) {
  switch (timer) {
    case TimerEnum.minutes_30:
      return const Duration(minutes: 30);
    case TimerEnum.minutes_60:
      return const Duration(minutes: 60);
    case TimerEnum.minutes_90:
      return const Duration(minutes: 90);
    case TimerEnum.minutes_120:
      return const Duration(minutes: 120);
  }
}

class TimerConfig {
  final TimerEnum timer;
  final String desc;

  TimerConfig(this.timer, this.desc);
}

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  final List<TimerConfig> configs = [
    TimerConfig(TimerEnum.minutes_30, "30 minutes"),
    TimerConfig(TimerEnum.minutes_60, "60 minutes"),
    TimerConfig(TimerEnum.minutes_90, "90 minutes"),
    TimerConfig(TimerEnum.minutes_120, "120 minutes")
  ];

  @override
  initState() {
    super.initState();
    getTimeConfig().then((value) => {
          setState(() {
            _timer = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: configs
            .map((config) => ListTile(
                  title: Text(config.desc),
                  leading: Radio<TimerEnum>(
                    value: config.timer,
                    groupValue: _timer,
                    onChanged: (TimerEnum? value) {
                      setState(() {
                        _timer = value;
                        saveTimeConfig(value!);
                      });
                    },
                  ),
                ))
            .toList());
  }
}
