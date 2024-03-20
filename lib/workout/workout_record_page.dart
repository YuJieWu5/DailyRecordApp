import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:cpsc5250hw/workout/workout_history.dart';
import 'package:cpsc5250hw/workout/workout_record_form.dart';
import '../auth_info.dart';
import '../last_record.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/app_options.dart';

class WorkoutRecordPage extends StatefulWidget {
  const WorkoutRecordPage({super.key});

  @override
  State<WorkoutRecordPage> createState() => _WorkoutRecordPageState();
}

class _WorkoutRecordPageState extends State<WorkoutRecordPage> {

  @override
  Widget build(BuildContext context) {
    Future<LastRecord> futureLastRecords = context.select<LastRecordViewModel,Future<LastRecord>>(
            (viewModel)=> viewModel.getLastRecord()
    );
    final appOptions = context.watch<AppOptions>();


    return FutureBuilder(
        future: futureLastRecords,
        builder: (context, snapshot){
          final lastRecord = snapshot.hasData?snapshot.data!:null;

          if(appOptions.style == WidgetStyle.cupertino){
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: CupertinoTheme.of(context).primaryColor,
                leading: Text(
                  '${AppLocalizations.of(context)!.points} ${snapshot.hasData ? lastRecord!.points : 0}',
                  style: TextStyle(color: CupertinoTheme.of(context).primaryContrastingColor),
                ),
                middle: Text(
                  '${AppLocalizations.of(context)!.workRecordPage}\n'
                      '${AppLocalizations.of(context)!.lastUpdate} ${snapshot.hasData ? lastRecord!.type + " " + lastRecord!.date.toString().split(" ")[0] : ""}',
                  style: TextStyle(color: CupertinoTheme.of(context).primaryContrastingColor, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: const [
                          SizedBox(height: 600, child: WorkoutRecordForm()),
                          SizedBox(height: 1200, child: WorkoutHistory()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            onPressed: () => GoRouter.of(context).push("/"),
                            child: Text(AppLocalizations.of(context)!.emotionRecordPage),
                          ),
                          CupertinoButton(
                            onPressed: () => GoRouter.of(context).push("/leaderboard"),
                            child: Text(AppLocalizations.of(context)!.leaderboard),
                          ),
                          CupertinoButton(
                            onPressed: () => GoRouter.of(context).push("/diet"),
                            child: Text(AppLocalizations.of(context)!.dietRecordPage),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  leading: Text('${AppLocalizations.of(context)!.points} ${snapshot.hasData?lastRecord!.points:0}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  title: Center(
                      child: Text('${AppLocalizations.of(context)!.workRecordPage}\n'
                          '${AppLocalizations.of(context)!.lastUpdate} ${snapshot.hasData? lastRecord!.type+" "+lastRecord!.date.toString().split(" ")[0]: ""}'
                          ,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 14),
                      )
                  )
              ),
              body: ListView(
                children: const[
                  SizedBox(height: 600, child: WorkoutRecordForm()),
                  SizedBox(height: 1200, child: WorkoutHistory())
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                  child: Padding(
                  padding: const EdgeInsets.all(8),
                    child: OverflowBar(
                      overflowAlignment: OverflowBarAlignment.center,
                      alignment: MainAxisAlignment.center,
                      overflowSpacing: 5.0,
                      children: [
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/emotion"), child: Text(AppLocalizations.of(context)!.emotionRecordPage)),
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/leaderboard"), child: Text(AppLocalizations.of(context)!.leaderboard)),
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/diet"), child: Text(AppLocalizations.of(context)!.dietRecordPage))
                      ],
                    ),
                  )
              ),
          );
        });
  }
}
