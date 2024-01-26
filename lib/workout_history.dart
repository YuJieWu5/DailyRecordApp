import 'package:flutter/material.dart';
import './workout_record.dart';

class WorkoutHistory extends StatelessWidget {
  final List<WorkoutRecord> _workoutRecords;
  const WorkoutHistory(this._workoutRecords, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _workoutRecords.map((record)=> ListTile(
        title: Text(record.workout),
        subtitle: Text('${record.duration}'),
        trailing: Text('${record.date.toString().split(' ')[0]}'),
      )).toList(),
    );
  }
}
