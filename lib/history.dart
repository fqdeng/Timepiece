import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timepiece/domain/event.dart';
import 'package:timepiece/storage/configs.dart';

import 'domain/event.dart';
import 'domain/history.entity.dart';
import 'event_bus.dart';

convertHistoryItemEnum(HistoryItemEnum item) {
  switch (item) {
    case HistoryItemEnum.start:
      return const Icon(Icons.start_rounded);
    case HistoryItemEnum.pause:
      return const Icon(Icons.pause_circle);
    case HistoryItemEnum.stop:
      return const Icon(Icons.stop_circle);
    default:
      return Container();
  }
}

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _History();
}

class _History extends State<History> {
  List<HistoryItem> _histories = [];
  late StreamSubscription<HistoryItem> _onHistoryChangeSub;
  late StreamSubscription<ClearHistoryEvent> _onClearHistorySub;

  @override
  void initState() {
    super.initState();
    readHistories().then(
      (value) => setState(() {
        if (value == null) {
          return;
        }
        _histories = value;
      }),
    );
    _onHistoryChangeSub = eventBus.on<HistoryItem>().listen((event) {
      setState(() {
        _histories.add(event);
        saveHistory(_histories);
      });
    });
    _onClearHistorySub = eventBus.on<ClearHistoryEvent>().listen((event) {
      setState(() {
        _histories.clear();
        saveHistory(_histories);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onHistoryChangeSub.cancel();
    _onClearHistorySub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: _histories.length,
        itemBuilder: (context, index) {
          final history = _histories[index];
          return Card(
            child: ListTile(
              leading: convertHistoryItemEnum(history.item),
              title: Text(history.item.toString()),
              subtitle: Text(history.time.toString()),
            ),
          );
        },
      ),
    );
  }
}
