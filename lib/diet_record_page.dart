import 'package:cpsc5250hw/diet_history.dart';
import 'package:cpsc5250hw/diet_record_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'last_record.dart';
import 'last_record_view_model.dart';
import 'package:go_router/go_router.dart';

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
                  leading: Text('Points: ${snapshot.hasData?lastRecord!.points:0}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  title: Center(
                      child: Text('Diet Record Page\n'
                          'Last Update: ${snapshot.hasData? lastRecord!.type+" "+lastRecord!.date.toString().split(" ")[0]: ""}'
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
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/workout"), child: const Text('Workout Record')),
                        TextButton(onPressed: ()=> GoRouter.of(context).push("/"), child: const Text('Emotion Record'))
                      ],
                    ),
                  )

              ),
          );
        });
  }
}
