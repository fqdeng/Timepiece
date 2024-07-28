import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../storage/configs.dart';

DurationEnum? _duration = DurationEnum.minutes_10;

Duration getDuration() {
  return convertToMinutes(_duration!);
}

enum DurationEnum { minutes_5, minutes_10, minutes_15, minutes_20, minutes_30 }

Duration convertToMinutes(DurationEnum duration) {
  switch (duration) {
    case DurationEnum.minutes_5:
      return const Duration(minutes: 5);
    case DurationEnum.minutes_10:
      return const Duration(minutes: 10);
    case DurationEnum.minutes_15:
      return const Duration(minutes: 15);
    case DurationEnum.minutes_20:
      return const Duration(minutes: 20);
    case DurationEnum.minutes_30:
      return const Duration(minutes: 30);
  }
}

class DurationSetting extends StatefulWidget {
  const DurationSetting({super.key});

  @override
  State<DurationSetting> createState() => _DurationSettingState();
}

class DurationConfig {
  final DurationEnum duration;
  final String desc;

  DurationConfig(this.duration, this.desc);
}

class _DurationSettingState extends State<DurationSetting> {
  final List<DurationConfig> configs = [
    DurationConfig(DurationEnum.minutes_5, "5 minutes"),
    DurationConfig(DurationEnum.minutes_10, "10 minutes"),
    DurationConfig(DurationEnum.minutes_15, "15 minutes"),
    DurationConfig(DurationEnum.minutes_20, "20 minutes"),
    DurationConfig(DurationEnum.minutes_30, "30 minutes")
  ];

  @override
  initState() {
    super.initState();

    getDurationConfig().then((value) => {
          setState(() {
            _duration = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: configs
            .map((config) => ListTile(
                  title: Text(config.desc),
                  leading: Radio<DurationEnum>(
                    value: config.duration,
                    groupValue: _duration,
                    onChanged: (DurationEnum? value) {
                      setState(() {
                        _duration = value;
                        saveDurationConfig(value!);
                      });
                    },
                  ),
                ))
            .toList());
  }
}
