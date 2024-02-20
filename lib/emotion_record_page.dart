import 'package:cpsc5250hw/emotion_history.dart';
import 'package:cpsc5250hw/emotion_record_form.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:cpsc5250hw/last_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/app_options.dart';

class EmotionRecordPage extends StatefulWidget {
  const EmotionRecordPage({super.key});

  @override
  State<EmotionRecordPage> createState() => _EmotionRecordPageState();
}

class _EmotionRecordPageState extends State<EmotionRecordPage> {


  @override
  Widget build(BuildContext context) {
    // final LastRecord lastRecord = await context.watch<LastRecordViewModel>().getLastRecord();
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
                    '${AppLocalizations.of(context)!.emotionRecordPage}\n${AppLocalizations.of(context)!.lastUpdate} ${snapshot.hasData ? lastRecord!.type + " " + lastRecord!.date.toString().split(" ")[0] : ""}',
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
                            SizedBox(height: 600, child: EmotionRecordForm()),
                            SizedBox(height: 1200, child: EmotionHistory()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              onPressed: () => GoRouter.of(context).push("/workout"),
                              child: Text(AppLocalizations.of(context)!.workRecordPage),
                            ),
                            CupertinoButton(
                              onPressed: () => GoRouter.of(context).push("/diet"),
                              child: Text(AppLocalizations.of(context)!.dietRecordPage),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                )
              );
            }
            return Scaffold(
                appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    leading: Text('${AppLocalizations.of(context)!.points} ${snapshot.hasData?lastRecord!.points:0}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                    title: Center(
                        child: Text('${AppLocalizations.of(context)!.emotionRecordPage}\n'
                            '${AppLocalizations.of(context)!.lastUpdate} ${snapshot.hasData? lastRecord!.type+" "+lastRecord!.date.toString().split(" ")[0]: ""}'
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
                      TextButton(onPressed: ()=> GoRouter.of(context).push("/workout"), child: Text(AppLocalizations.of(context)!.workRecordPage)),
                      TextButton(onPressed: ()=> GoRouter.of(context).push("/diet"), child: Text(AppLocalizations.of(context)!.dietRecordPage))
                    ],
                  ),
                )
              ),
            );
        });
  }
}
