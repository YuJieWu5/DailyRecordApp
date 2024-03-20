import 'package:cpsc5250hw/emotion/emotion_record_page.dart';
import 'package:cpsc5250hw/emotion/emotion_history.dart';
import 'package:cpsc5250hw/emotion/emotion_record.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

main(){
  testWidgets('Adding an emotion record updates the emotion history', (WidgetTester tester) async {
    // Render the EmotionRecordPage
    await tester.pumpWidget(
      MultiProvider(
          providers:[
            ChangeNotifierProvider(create: (context)=>RecordingPoints(0)),
            ChangeNotifierProvider(create: (context)=>LastRecordingInfo("", ""))
          ],
          child: MaterialApp(
              home: EmotionRecordPage()
          )
      ),
    );

    // Find the form fields and submit button, then interact with them
    // For example:
    await tester.tap(find.byType(DropdownMenu));
    // final dropdown = find.byKey(const ValueKey('Emotion'));
    await tester.tap(find.text("happy 😆"));
    await tester.pumpAndSettle(); // Rebuild the widget tree after the tap

    // await tester.pumpAndSettle();

    await tester.tap(find.byType(DateTimeFormField));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // await tester.enterText(find.byType(DropdownMenu, 'Happy');
    await tester.tap(find.byType(ElevatedButton));

    await tester.pump(); // Rebuild the widget with the new state

    // Verify that the EmotionRecord appears in the EmotionHistory list
    expect(find.text('happy'), findsOneWidget); // Update with actual expectation
  });
}