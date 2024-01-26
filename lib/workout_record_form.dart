import 'package:flutter/material.dart';
import 'workout_record.dart';

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

  // String? selectedWorkout = 'Running';
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _onSavePressed(){
    print("Workout: "+ _workoutController.text+ " Quantity: "+_durationController.text);
    if(_formKey.currentState?.validate()??false){
      WorkoutRecord record = new WorkoutRecord(_workoutController.text,
          double.parse(_durationController.text),
          DateTime.now()
      );
      widget.addWorkoutRecord(record);
      _formKey.currentState!.reset();
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
                child: Text('Date: ' + DateTime.now().toString().split(' ')[0], style: TextStyle(fontSize: 20))
            ),
            Center(
              child: DropdownMenu<String>(
                requestFocusOnTap: true,
                controller: _workoutController,
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
            SizedBox(
              width: 400.0,
              child: TextField(
                decoration: const InputDecoration(
                    labelText: 'Duration(mins)'
                ),
                controller: _durationController,
                keyboardType: TextInputType.number,
              )
            ),
            SizedBox(
              width: 400.0,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Date'
                ),
                keyboardType: TextInputType.datetime,
                controller: _dateController,
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
