import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'workout_record_entity.dart';
import 'workout_record_dao.dart';

part 'recorder_database.g.dart';

@Database(version: 1, entities:[WorkoutRecordEntity])
abstract class RecorderDatabase extends FloorDatabase {
  WorkoutRecordDao get workoutRecordDao;
}