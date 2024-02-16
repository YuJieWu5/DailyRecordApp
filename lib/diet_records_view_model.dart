import 'package:flutter/foundation.dart';
import 'diet_record.dart';
import 'diet_records_repository.dart';

class DietRecordsViewModel with ChangeNotifier{
  DietRecordsRepository _repository;

  DietRecordsViewModel(this._repository);

  addDietRecord(DietRecord record) async{
    await _repository.addDietRecord(record);
    notifyListeners();
  }

  Future<List<DietRecord>> listAllDietRecords(){
    return _repository.listAllDietRecords();
  }

  deleteDietRecord(String id) async{
    await _repository.deleteDietRecord(id);
    notifyListeners();
  }

  updateDietRecord(String id, double quantity) async{
    await _repository.updateDietRecord(id, quantity);
    notifyListeners();
  }
}