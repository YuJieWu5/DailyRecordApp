import 'package:cpsc5250hw/emotion_history.dart';
import 'package:cpsc5250hw/emotion_record_form.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'emotion_record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionRecordPage extends StatefulWidget {
  const EmotionRecordPage({super.key});

  @override
  State<EmotionRecordPage> createState() => _EmotionRecordPageState();
}

class _EmotionRecordPageState extends State<EmotionRecordPage> {
  final List<EmotionRecord> _emotionRecords = [];

  _addEmotionRecord(EmotionRecord emotionRecord){
    setState(() {
      _emotionRecords.add(emotionRecord);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('re-building Emotion page');
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Center(
              child: Text('RecordingPoints: ${context.watch<RecordingPoints>().getRecordingPoints()}\t'
                  'Last Update: ${context.watch<LastRecordingInfo>().getRecordingDate()} ${context.watch<LastRecordingInfo>().getRecordingType()}\n'
                  'Emotion Record Page',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  )
            )
        ),
        body: ListView(
          children: [
            SizedBox(height: 600, child: EmotionRecordForm(_addEmotionRecord)),
            SizedBox(height: 1200, child: EmotionHistory(_emotionRecords))
          ],
        )
    );
  }
}
