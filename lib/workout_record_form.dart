import 'package:flutter/material.dart';
import 'last_record.dart';
import 'last_record_view_model.dart';
import 'workout_record.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/workout_records_view_model.dart';
import 'package:date_field/date_field.dart';
import 'package:uuid/uuid.dart';

class WorkoutRecordForm extends StatefulWidget {
  const WorkoutRecordForm({super.key});

  @override
  State<WorkoutRecordForm> createState() => _WorkoutRecordForm();
}

class _WorkoutRecordForm extends State<WorkoutRecordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _workoutList = ['Running', 'Swimming', 'Cycling', 'Yoga', 'StrengthTraining',
    'HIIT', 'Pilates', 'Boxing'];
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _dropdownError;
  DateTime _dateTime = DateTime.now();
  var uuid = Uuid();

  void _onSavePressed(){
    print("Workout: "+ _workoutController.text+ " Quantity: "+_durationController.text);
    if (_workoutController.text == null || _workoutController.text.isEmpty) {
      _dropdownError = 'Workout must not be blank.';
      _formKey.currentState?.validate();
      setState(() {});
    } else {
      _dropdownError = null;
      if(_formKey.currentState?.validate()??false){
        WorkoutRecord record = WorkoutRecord(
            uuid.v4(),
            _workoutController.text,
            double.parse(_durationController.text),
            _dateTime
        );
        LastRecord lastRecord = LastRecord("Workout Record", DateTime.now(),3);
        context.read<WorkoutRecordsViewModel>().addWorkoutRecord(record);
        context.read<LastRecordViewModel>().addLastRecord(lastRecord);
        _formKey.currentState!.reset();
      }
      setState(() {
        _dateTime = DateTime.now();
        _durationController.clear();
        _workoutController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Column(
          children:[
            Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Center(
                    child: DropdownMenu<String>(
                      width: 400.0,
                      requestFocusOnTap: false,
                      controller: _workoutController,
                      errorText: _dropdownError,
                      label: Text(AppLocalizations.of(context)!.workout),
                      dropdownMenuEntries: _workoutList
                          .map<DropdownMenuEntry<String>>(
                              (String workout){
                            return DropdownMenuEntry<String>(
                              value: workout,
                              label: AppLocalizations.of(context)!.workoutList(workout),
                            );
                          }).toList(),
                    )
                ),
            ),
            SizedBox(
              width: 400.0,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.duration
                ),
                controller: _durationController,
                keyboardType: TextInputType.number,
                validator: (newValue) {
                  if(newValue == null || newValue.isEmpty) {
                    return 'Duration must not be blank.';
                  }
                  return null;
                },
              )
            ),
            SizedBox(
              width: 400.0,
              child: DateTimeFormField(
                firstDate: DateTime(DateTime.now().year, DateTime.now().month),
                lastDate: DateTime.now(),
                mode: DateTimeFieldPickerMode.date,
                initialPickerDateTime: DateTime.now(),
                onChanged: (newDate) {
                  if(newDate != null) {
                    setState(() {
                      _dateTime = newDate;
                    });
                  }
                },
                validator: (newValue) {
                  if(newValue == null) {
                    return 'Date must not be blank.';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: _onSavePressed,
                  child: Text(AppLocalizations.of(context)!.save)
              ),
            ),
          ]
        )
      )
    );
  }

}
