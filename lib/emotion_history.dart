import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './emotion_record.dart';
import 'package:cpsc5250hw/emotion_records_view_model.dart';

class EmotionHistory extends StatefulWidget {
  const EmotionHistory({super.key});

  @override
  createState() => _EmotionHistory();
}

class _EmotionHistory extends State<EmotionHistory> {

  void _onDeletePressed(String id){
    context.read<EmotionRecordsViewModel>().deleteEmotionRecord(id);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<EmotionRecord>> futureEmotionRecords = context.select<
        EmotionRecordsViewModel,
        Future<List<EmotionRecord>>>(
            (viewModel) => viewModel.listAllEmotionRecords()
    );
    return FutureBuilder(
        future: futureEmotionRecords,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final emotionRecords = snapshot.data!;
            return Column(
              children: emotionRecords.map((record) =>
                  ListTile(
                    leading: Text(record.icon),
                    title: Text(record.emotion),
                    subtitle: Text('${record.date.toString().split(' ')[0]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        _onDeletePressed(record.id);
                      },
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
    );
  }
}
