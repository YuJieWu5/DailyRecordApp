import 'package:flutter/foundation.dart';
import 'workout_record.dart';
import 'workout_records_repository.dart';

class WorkoutRecordsViewModel with ChangeNotifier{
  WorkoutRecordsRepository _repository;

  WorkoutRecordsViewModel(this._repository);
  addWorkoutRecord(WorkoutRecord record) async{
    await _repository.addWorkoutRecord(record);
    notifyListeners();
  }

  Future<List<WorkoutRecord>> listAllWorkoutRecords(){
    return _repository.listAllWorkoutRecords();
  }

  deleteWorkoutRecord(int id) async{
    await _repository.deleteWorkoutRecord(id);
    notifyListeners();
  }
}

