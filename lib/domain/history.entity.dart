
enum HistoryItemEnum { stop, pause, start }

class HistoryItem {
  final HistoryItemEnum item;
  final String time;

  HistoryItem(this.item, this.time);

  HistoryItem.fromJson(Map<String, dynamic> json)
      : item = HistoryItemEnum.values[json['item']],
        time = json['time'];

  Map<String, dynamic> toJson() => {'item': item.index, 'time': time};
}