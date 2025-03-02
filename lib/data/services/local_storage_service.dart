import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class LocalStorageService {
  final Box<String> _stackHistoryBox = Hive.box<String>('stackHistory');

  void addHistory(String trace) {
    _stackHistoryBox.add(trace);
  }

  List<String> getHistory() {
    return _stackHistoryBox.values.toList().reversed.toList();
  }
    Future<void> clearHistory() async{
     _stackHistoryBox.clear();
  }

  ValueListenable<Box<String>> historyListener() {
    return _stackHistoryBox.listenable();
  }
}
