import 'package:cpsc5250hw/workout_records_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './workout_record.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({super.key});

  @override
  createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  // final List<WorkoutRecord> _workoutRecords;
  // const WorkoutHistory(this._workoutRecords, {super.key});

  void _onDeletePressed(String id){
    context.read<WorkoutRecordsViewModel>().deleteWorkoutRecord(id);
  }


  @override
  Widget build(BuildContext context) {
    Future<List<WorkoutRecord>> futureWorkoutRecords = context.select<WorkoutRecordsViewModel,Future<List<WorkoutRecord>>>(
        (viewModel)=> viewModel.listAllWorkoutRecords()
    );
    return FutureBuilder(
        future: futureWorkoutRecords,
        builder: (context, snapshot){
          if(snapshot.hasData){
            final workoutRecords = snapshot.data!;
            return Column(
              children: workoutRecords.map((record)=> ListTile(
                  title: Text(record.workout),
                  subtitle: Text('${record.duration} ${record.date.toString().split(' ')[0]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:(){
                      _onDeletePressed(record.id);
                    }
                  ),
                )).toList(),
            );
          }else if(snapshot.hasError){
            return const Text('An error occurred trying to load your data and we have no idea what to do about it. Sorry.');
          }else{
            return const CircularProgressIndicator();
          }
        }
      );
    // return Column(
    //   children: _workoutRecords.map((record)=> ListTile(
    //     title: Text(record.workout),
    //     subtitle: Text('${record.duration}'),
    //     trailing: Text('${record.date.toString().split(' ')[0]}'),
    //   )).toList(),
    // );
  }
}
