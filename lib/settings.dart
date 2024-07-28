import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'config/timer_config.dart';
import 'config/duration_config.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Column(children: [
      Card(
        shadowColor: Colors.transparent,
        margin: EdgeInsets.all(8.0),
        child: SizedBox(
            child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.timelapse_sharp),
              title: Text('Duration'),
              subtitle: Text(
                  'How long do you want to notify you? every 10 minutes or 20 minutes or more?'),
            ),
            DurationSetting(),
          ],
        )),
      ),
      Card(
        shadowColor: Colors.transparent,
        margin: EdgeInsets.all(8.0),
        child: SizedBox(
            child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.alarm_on),
              title: Text('Global'),
              subtitle: Text('How long do you want to notify you eventually?'),
            ),
            Timer(),
          ],
        )),
      )
    ]));
  }
}
