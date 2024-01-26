import 'package:flutter/material.dart';
import './emotion_record.dart';

class EmotionHistory extends StatelessWidget {
  final List<EmotionRecord> _emotionRecords;
  const EmotionHistory(this._emotionRecords, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _emotionRecords.map((record)=> ListTile(
        leading: Text(record.icon),
        title: Text(record.emotion),
        trailing: Text('${record.date.toString().split(' ')[0]}'),
      )).toList(),
    );
  }
}
