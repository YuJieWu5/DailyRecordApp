import 'package:flutter/foundation.dart';
import './emotion_record.dart';
import 'emotion_records_repository.dart';

class EmotionRecordsViewModel with ChangeNotifier{
  EmotionRecordsRepository _repository;

  EmotionRecordsViewModel(this._repository);

  addEmotionRecord(EmotionRecord record) async{
    await _repository.addEmotionRecord(record);
    notifyListeners();
  }

  Future<List<EmotionRecord>> listAllEmotionRecords(){
    return _repository.listAllEmotionRecords();
  }

  deleteEmotionRecord(String id) async{
    await _repository.deleteEmotionRecord(id);
    notifyListeners();
  }
}

