import 'package:flutter/foundation.dart';
import 'package:cpsc5250hw/last_record.dart';
import 'last_record_repository.dart';
import 'dart:async';

class LastRecordViewModel with ChangeNotifier{
  LastRecordsRepository _repository;
  LastRecordViewModel(this._repository);

  addLastRecord(LastRecord record)async{
    await _repository.addLastRecord(record);
    notifyListeners();
  }

  Future<LastRecord> getLastRecord(){
    return _repository.getLastRecord();
  }
}