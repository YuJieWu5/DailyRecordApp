import 'package:cpsc5250hw/emotion_records_view_model.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:cpsc5250hw/workout_records_view_model.dart';
import 'package:cpsc5250hw/diet_records_view_model.dart';
import './emotion_record_page.dart';
import './diet_record_page.dart';
import './workout_record_page.dart';
import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/floor_workout_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_diet_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_emotion_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_last_record_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  RecorderDatabase database = await $FloorRecorderDatabase.databaseBuilder('recorder.db').build();
  runApp(MyApp(database));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const EmotionRecordPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'diet',
          builder: (BuildContext context, GoRouterState state) {
            return const DietRecordPage();
          },
        ),
        GoRoute(
          path: 'workout',
          builder: (BuildContext context, GoRouterState state) {
            return const WorkoutRecordPage();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  final RecorderDatabase database;
  const MyApp(this.database, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (context)=>RecordingPoints(0)),
          // ChangeNotifierProvider(create: (context)=>LastRecordingInfo("", "")),
          ChangeNotifierProvider(create: (context)=>EmotionRecordsViewModel(FloorEmotionRecordsRepository(database))),
          ChangeNotifierProvider(create: (context)=>WorkoutRecordsViewModel(FloorWorkoutRecordsRepository(database))),
          ChangeNotifierProvider(create: (context)=>DietRecordsViewModel(FloorDietRecordsRepository(database))),
          ChangeNotifierProvider(create: (context)=>LastRecordViewModel(FloorLastRecordRepository(database))),
        ],
      child: MaterialApp.router(
        routerConfig: _router,
      )
      // MaterialApp(
      //     title: 'Flutter Demo',
      //     theme: ThemeData(
      //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //       useMaterial3: true,
      //     ),
      //     home: PageView.builder(
      //         itemCount: 3,
      //         itemBuilder: (context, index){
      //           switch(index){
      //             case 0:
      //               return const EmotionRecordPage();
      //               break;
      //             case 1:
      //               return const DietRecordPage();
      //               break;
      //             case 2:
      //               return const WorkoutRecordPage();
      //               break;
      //           }
      //         }
      //     )
      // )
    );
  }
}
