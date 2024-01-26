import 'package:cpsc5250hw/emotion_history.dart';
import 'package:cpsc5250hw/emotion_record_form.dart';
import 'emotion_record.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
        appBar: AppBar(
            title: const Center(
              child: Text('Emotion Record Page'),
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
