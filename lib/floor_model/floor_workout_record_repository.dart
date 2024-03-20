import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/workout_record_entity.dart';
import 'package:cpsc5250hw/workout/workout_records_repository.dart';
import 'package:cpsc5250hw/workout/workout_record.dart';
import 'package:uuid/uuid.dart';

class FloorWorkoutRecordsRepository implements WorkoutRecordsRepository{
  RecorderDatabase _database;
  var uuid = Uuid();

  FloorWorkoutRecordsRepository(this._database);

  @override
  Future<void> addWorkoutRecord(WorkoutRecord record) async{
    WorkoutRecordEntity entity = WorkoutRecordEntity(
        record.id,
        record.workout,
        record.duration,
        record.date.millisecondsSinceEpoch
    );
    await _database.workoutRecordDao.addWorkoutRecord(entity);
  }

  @override
  Future<void> deleteWorkoutRecord(String id) async{
    await _database.workoutRecordDao.deleteWorkoutRecord(id);
  }

  @override
  Future<List<WorkoutRecord>> listAllWorkoutRecords() async{
    final entities = await _database.workoutRecordDao.listAllWorkoutRecord();
    return entities.map(_covertFromDatabase).toList();
  }

  WorkoutRecord _covertFromDatabase(WorkoutRecordEntity entity) => WorkoutRecord(
      entity.id,
      entity.workout,
      entity.duration,
      DateTime.fromMillisecondsSinceEpoch(entity.date)
  );
}