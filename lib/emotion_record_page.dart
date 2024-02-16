import 'package:cpsc5250hw/emotion_history.dart';
import 'package:cpsc5250hw/emotion_record_form.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:cpsc5250hw/last_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class EmotionRecordPage extends StatefulWidget {
  const EmotionRecordPage({super.key});

  @override
  State<EmotionRecordPage> createState() => _EmotionRecordPageState();
}

class _EmotionRecordPageState extends State<EmotionRecordPage> {


  @override
  Widget build(BuildContext context) {
    // final LastRecord lastRecord = await context.watch<LastRecordViewModel>().getLastRecord();
    print("rebuild emotion page");
    Future<LastRecord> futureLastRecords = context.select<LastRecordViewModel,Future<LastRecord>>(
            (viewModel)=> viewModel.getLastRecord()
    );

    return FutureBuilder(
        future: futureLastRecords,
        builder: (context, snapshot){
          // if(snapshot.hasData){
            final lastRecord = snapshot.hasData?snapshot.data!:null;
            return Scaffold(
                appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    leading: Text('Points: ${snapshot.hasData?lastRecord!.points:0}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    title: Center(
                        child: Text('Emotion Record Page\n'
                            'Last Update: ${snapshot.hasData? lastRecord!.type+" "+lastRecord!.date.toString().split(" ")[0]: ""}'
                            ,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14),
                        )
                    )
                ),
                body: ListView(
                  children: const[
                    SizedBox(height: 600, child: EmotionRecordForm()),
                    SizedBox(height: 1200, child: EmotionHistory())
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
                      TextButton(onPressed: ()=> GoRouter.of(context).push("/diet"), child: const Text('Diet Record'))
                    ],
                  ),
                )
              ),
            );
        });
  }
}
