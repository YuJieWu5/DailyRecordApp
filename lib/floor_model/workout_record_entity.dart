import 'package:floor/floor.dart';

@Entity(tableName: "WorkoutRecord")
class WorkoutRecordEntity{
  @primaryKey
  final String id;
  final String workout;
  final double duration;
  final int date;

  WorkoutRecordEntity(this.id, this.workout, this.duration, this.date);
}