import 'package:cpsc5250hw/emotion/emotion_records_view_model.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:cpsc5250hw/recording_points_dao.dart';
import 'package:cpsc5250hw/workout/workout_records_view_model.dart';
import 'package:cpsc5250hw/diet/diet_records_view_model.dart';
import 'emotion/emotion_record_page.dart';
import '../diet/diet_record_page.dart';
import '../workout/workout_record_page.dart';
import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/floor_workout_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_diet_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_emotion_record_repository.dart';
import 'package:cpsc5250hw/floor_model/floor_last_record_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/app_options.dart';
import 'package:cpsc5250hw/language_options.dart';
import 'package:cpsc5250hw/firebase_initializer.dart';
import 'package:cpsc5250hw/sign_in.dart';
import 'package:cpsc5250hw/sign_up.dart';
import 'package:cpsc5250hw/leaderboard_page.dart';
import 'package:cpsc5250hw/auth_info.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  RecorderDatabase database = await $FloorRecorderDatabase.databaseBuilder('recorder.db').build();
  runApp(FirebaseInitializer(widget: MyApp(database)));
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
          path: 'leaderboard',
          builder: (BuildContext context, GoRouterState state) {
            return const LeaderboardPage();
          },
        ),
        GoRoute(
          path: 'emotion',
          builder: (BuildContext context, GoRouterState state) {
            return const EmotionRecordPage();
          },
        ),
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
        GoRoute(
          path: 'signIn',
          builder: (BuildContext context, GoRouterState state) {
            return const SignInPage();
          },
        ),
        GoRoute(
          path: 'signUp',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
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
        Provider(create: (context)=> PointsDao()),
        ChangeNotifierProvider(create: (context)=> AuthInfo(null, null)),
        ChangeNotifierProvider(create: (context)=>  LocaleProvider()),
        ChangeNotifierProvider(create: (context)=> AppOptions(WidgetStyle.material)),
        ChangeNotifierProvider(create: (context) => EmotionRecordsViewModel(FloorEmotionRecordsRepository(database))),
        ChangeNotifierProvider(create: (context) => WorkoutRecordsViewModel(FloorWorkoutRecordsRepository(database))),
        ChangeNotifierProvider(create: (context) => DietRecordsViewModel(FloorDietRecordsRepository(database))),
        ChangeNotifierProvider(create: (context) => LastRecordViewModel(FloorLastRecordRepository(database))),
      ],
      child: AppWidget(database: database)
    );
  }
}

class AppWidget extends StatelessWidget {
  final RecorderDatabase database;
  const AppWidget({required this.database, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      locale: context.watch<LocaleProvider>().locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
