import 'package:cpsc5250hw/workout_records_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './workout_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:cpsc5250hw/app_options.dart';

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

    final appOptions = context.watch<AppOptions>();

    return FutureBuilder(
        future: futureWorkoutRecords,
        builder: (context, snapshot) {
          if (appOptions.style == WidgetStyle.cupertino) {
            if (snapshot.hasData) {
              final workoutRecords = snapshot.data!;
              return Column(
                children: workoutRecords.map((record) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.workout,
                              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                            ),
                            Text(
                              '${record.duration} ${record.date.toString().split(' ')[0]}',
                              style: CupertinoTheme.of(context).textTheme.textStyle,
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _onDeletePressed(record.id);
                        },
                        child: const Icon(
                          CupertinoIcons.delete,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              );
            } else if (snapshot.hasError) {
              return const Text(
                'An error occurred trying to load your data and we have no idea what to do about it. Sorry.',
                style: TextStyle(color: CupertinoColors.systemGrey),
              );
            } else {
              return const CupertinoActivityIndicator();
            }
          }
          else {
            if (snapshot.hasData) {
              final workoutRecords = snapshot.data!;
              return Column(
                children: workoutRecords.map((record) =>
                    ListTile(
                      title: Text(record.workout),
                      subtitle: Text(
                          '${record.duration} ${record.date.toString().split(
                              ' ')[0]}'),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _onDeletePressed(record.id);
                          }
                      ),
                    )).toList(),
              );
            } else if (snapshot.hasError) {
              return const Text(
                  'An error occurred trying to load your data and we have no idea what to do about it. Sorry.');
            } else {
              return const CircularProgressIndicator();
            }
          }
        }
      );
  }
}
