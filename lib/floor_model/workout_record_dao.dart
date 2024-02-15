import 'package:floor/floor.dart';
import 'workout_record_entity.dart';

@dao
abstract class WorkoutRecordDao{
  @insert
  Future<void> addWorkoutRecord(WorkoutRecordEntity record);
  @Query('SELECT * FROM SpendingEvent')
  Future<List<WorkoutRecordEntity>> listAllWorkoutRecord();
  @Query('DELETE FROM items WHERE id = :id')
  Future<void> deleteWorkoutRecord(String id);
}