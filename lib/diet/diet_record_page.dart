import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpsc5250hw/diet/diet_history.dart';
import 'package:cpsc5250hw/diet/diet_record_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_info.dart';
import '../last_record.dart';
import '../last_record_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DietRecordPage extends StatefulWidget {
  const DietRecordPage({super.key});

  @override
  State<DietRecordPage> createState() => _DietRecordPageState();
}

class _DietRecordPageState extends State<DietRecordPage> {

  @override
  Widget build(BuildContext context) {
    Future<LastRecord> futureLastRecords = context.select<LastRecordViewModel,Future<LastRecord>>(
            (viewModel)=> viewModel.getLastRecord()
    );

    return FutureBuilder(
        future: futureLastRecords,
        builder: (context, snapshot){
          final lastRecord = snapshot.hasData?snapshot.data!:null;

          return Scaffold(
              appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  leading: Text('${AppLocalizations.of(context)!.points} ${snapshot.hasData?lastRecord!.points:0}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  title: Center(
                      child: Text('${AppLocalizations.of(context)!.dietRecordPage}\n'
                          '${AppLocalizations.of(context)!.lastUpdate} ${snapshot.hasData? lastRecord!.type+" "+lastRecord!.date.toString().split(" ")[0]: ""}'
                          ,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14),
                      )
                  )
              ),
              body: ListView(
                children: const[
                  SizedBox(height: 600, child: DietRecordForm()),
                  SizedBox(height: 1200, child: DietHistory())
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
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/workout"), child: Text(AppLocalizations.of(context)!.workRecordPage)),
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/leaderboard"), child: Text(AppLocalizations.of(context)!.leaderboard)),
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/emotion"), child: Text(AppLocalizations.of(context)!.emotionRecordPage))
                      ],
                    ),
                  )

              ),
          );
        });
  }
}
