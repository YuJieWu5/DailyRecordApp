import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './emotion_record.dart';
import 'package:cpsc5250hw/emotion_records_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:cpsc5250hw/app_options.dart';

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
    final appOptions = context.watch<AppOptions>();

    return FutureBuilder(
        future: futureEmotionRecords,
        builder: (context, snapshot) {
          if (appOptions.style == WidgetStyle.cupertino) {
            if (snapshot.hasData) {
              final emotionRecords = snapshot.data!;
              return Column(
                children: emotionRecords.map((record) => Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          record.icon,
                          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.emotion,
                              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                            ),
                            Text(
                              '${record.date.toString().split(' ')[0]}',
                              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 15),
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
              return CupertinoActivityIndicator();
            }
          }
          else {
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
                        onPressed: () {
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
        }
    );
  }
}
