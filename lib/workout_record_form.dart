import 'package:flutter/material.dart';
import 'workout_record.dart';
import 'package:provider/provider.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'package:date_field/date_field.dart';

class WorkoutRecordForm extends StatefulWidget {
  final void Function(WorkoutRecord workoutRecord) addWorkoutRecord;
  const WorkoutRecordForm(this.addWorkoutRecord, {super.key});

  @override
  State<WorkoutRecordForm> createState() => _WorkoutRecordForm();
}

class _WorkoutRecordForm extends State<WorkoutRecordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _workoutList = ['Running', 'Swimming', 'Cycling', 'Yoga', 'Strength Training',
    'High-Intensity Interval Training (HIIT)', 'Pilates', 'Boxing'];
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _dropdownError;
  DateTime _dateTime = DateTime.now();

  void _onSavePressed(){
    print("Workout: "+ _workoutController.text+ " Quantity: "+_durationController.text);
    if (_workoutController.text == null || _workoutController.text.isEmpty) {
      _dropdownError = 'Workout must not be blank.';
      _formKey.currentState?.validate();
      setState(() {});
    } else {
      _dropdownError = null;
      setState(() {});
      if(_formKey.currentState?.validate()??false){
        WorkoutRecord record = new WorkoutRecord(
            _workoutController.text,
            double.parse(_durationController.text),
            _dateTime
        );
        context.read<LastRecordingInfo>().setRecordingDate(_dateTime.toString());
        context.read<LastRecordingInfo>().setRecordingType("Workout Record");
        context.read<RecordingPoints>().setRecordingPoints(context.read<RecordingPoints>().getRecordingPoints()+5);
        _dateTime = DateTime.now();
        _durationController.clear();
        _workoutController.clear();
        widget.addWorkoutRecord(record);
        _formKey.currentState!.reset();
      }
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
                      label: const Text('Workout'),
                      dropdownMenuEntries: _workoutList
                          .map<DropdownMenuEntry<String>>(
                              (String workout){
                            return DropdownMenuEntry<String>(
                              value: workout,
                              label: workout,
                            );
                          }).toList(),
                    )
                ),
            ),
            SizedBox(
              width: 400.0,
              child: TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Duration(mins)'
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
                  child: const Text('Save')
              ),
            ),
          ]
        )
      )
    );
  }

}
