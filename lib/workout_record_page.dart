import 'package:cpsc5250hw/workout_history.dart';
import 'package:cpsc5250hw/workout_record_form.dart';
import 'workout_record.dart';
import 'package:flutter/material.dart';

class WorkoutRecordPage extends StatefulWidget {
  const WorkoutRecordPage({super.key});

  @override
  State<WorkoutRecordPage> createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {
  final List<WorkoutRecord> _workoutRecords = [];

  _addWorkoutRecord(WorkoutRecord workoutRecord){
    setState(() {
      _workoutRecords.add(workoutRecord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Workout Page'),
        )
      ),
      body: ListView(
        children: [
          SizedBox(height: 500, child: WorkoutRecordForm(_addWorkoutRecord)),
          SizedBox(height: 48, child: Center(child: const Text('Workout History', style: TextStyle(fontSize: 20)))),
          SizedBox(height: 1200, child: WorkoutHistory(_workoutRecords))
        ],
      )
    );
  }
}
