import 'package:cpsc5250hw/workout/workout_history.dart';
import 'package:cpsc5250hw/workout/workout_record.dart';
import 'package:cpsc5250hw/workout/workout_record_form.dart';
import 'package:cpsc5250hw/workout/workout_record_page.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

main(){
  testWidgets('Add a workout record, find it in the workout history list', (WidgetTester tester) async{
    await tester.pumpWidget(
      MultiProvider(
          providers:[
            ChangeNotifierProvider(create: (context)=>RecordingPoints(0)),
            ChangeNotifierProvider(create: (context)=>LastRecordingInfo("", ""))
          ],
          child: MaterialApp(
              home: WorkoutRecordPage()
          )
      ),
    );

    await tester.tap(find.byType(DropdownMenu<String>));
    await tester.tap(find.text('Swimming'));
    await tester.pump(); // Rebuild the widget tree after the tap

    await tester.enterText(find.byType(TextField), '20');
    await tester.pump();

    await tester.tap(find.byType(DateTimeFormField));
    // await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.textContaining('20'), findsOneWidget);
    expect(find.text('Swimming'), findsOneWidget);
    // expect(find.text(DateTime.now().toString().split(' ')[0]), findsOneWidget);

  });
}