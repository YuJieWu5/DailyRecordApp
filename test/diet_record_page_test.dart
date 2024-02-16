import 'package:cpsc5250hw/diet_record_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:provider/provider.dart';

main(){
  testWidgets('Diet Record Page Testing', (WidgetTester tester) async{
    // await tester.pumpWidget(MaterialApp(home: Material(child: DietRecorder())));

    // await tester.pumpWidget(
    //   MultiProvider(
    //       providers:[
    //         ChangeNotifierProvider(create: (context)=>RecordingPoints(0)),
    //         ChangeNotifierProvider(create: (context)=>LastRecordingInfo("", ""))
    //       ],
    //       child: MaterialApp(
    //           home: DietRecorder()
    //       )
    //   ),
    // );
    //
    // await tester.enterText(find.byType(DropdownMenu<String>),'Banana');
    // await tester.pump();
    // await tester.enterText(find.byType(TextFormField), '20');
    // await tester.pump();
    // await tester.tap(find.byType(ElevatedButton));
    // await tester.pump();
    //
    // await tester.tap(find.byType(DropdownMenu<String>));
    // await tester.pump();
    // expect(find.text('banana'), findsOneWidget);

  });

}