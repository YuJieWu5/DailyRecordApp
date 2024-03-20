import './workout_record.dart';

abstract class WorkoutRecordsRepository{
  Future<void> addWorkoutRecord(WorkoutRecord record);
  Future<List<WorkoutRecord>> listAllWorkoutRecords();
  Future<void> deleteWorkoutRecord(String id);
}