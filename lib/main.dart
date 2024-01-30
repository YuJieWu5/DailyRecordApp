import './emotion_record_page.dart';
import './diet_recorder.dart';
import './workout_record_page.dart';
import './last_recording_info.dart';
import './recording_points.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // final List<String> pages = ['Page 1', 'Page 2', 'Page 3'];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>RecordingPoints(0)),
          ChangeNotifierProvider(create: (context)=>LastRecordingInfo("", ""))
        ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, index){
                switch(index){
                  case 0:
                    return EmotionRecordPage();
                    break;
                  case 1:
                    return DietRecorder();
                    break;
                  case 2:
                    return WorkoutRecordPage();
                    break;
                }
              }
          )
      )
    );
  }
}
