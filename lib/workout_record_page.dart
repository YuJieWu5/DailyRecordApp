import 'package:cpsc5250hw/workout_history.dart';
import 'package:cpsc5250hw/workout_record_form.dart';
import 'workout_record.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:cpsc5250hw/last_recording_info.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Text('RecordingPoints: ${context.watch<RecordingPoints>().getRecordingPoints()}\t'
                      'Last Update: ${context.watch<LastRecordingInfo>().getRecordingDate()} ${context.watch<LastRecordingInfo>().getRecordingType()}\n'
                      'Workout Record Page',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          )
        )
      ),
      body: ListView(
        children: [
          SizedBox(height: 500, child: WorkoutRecordForm(_addWorkoutRecord)),
          SizedBox(height: 1200, child: WorkoutHistory(_workoutRecords))
        ],
      )
    );
  }
}
