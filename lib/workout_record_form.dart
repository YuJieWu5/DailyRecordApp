import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'last_record.dart';
import 'last_record_view_model.dart';
import 'workout_record.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/workout_records_view_model.dart';
import 'package:date_field/date_field.dart';
import 'package:uuid/uuid.dart';
import 'package:cpsc5250hw/app_options.dart';

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
  String? _selectedWorkout;
  String? _dropdownError;
  bool? _currentValue;
  DateTime _dateTime = DateTime.now();
  var uuid = Uuid();

  void _onSavePressed(){
    print("Workout: "+ _workoutController.text+ " Quantity: "+_durationController.text);
    if ((_workoutController.text == null || _workoutController.text.isEmpty) && _selectedWorkout==null) {
      _dropdownError = AppLocalizations.of(context)!.workoutErrorText;
      _formKey.currentState?.validate();
      setState(() {});
    } else {
      _dropdownError = null;
      if(_formKey.currentState?.validate()??false){
        print(_selectedWorkout);
        WorkoutRecord record = WorkoutRecord(
            uuid.v4(),
            _selectedWorkout?? _workoutController.text,
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

  void _onStyleChange(bool? newValue){
    print(newValue);
    setState(() {
      _currentValue = newValue;
      if(_currentValue!){
        context.read<AppOptions>().style = WidgetStyle.cupertino;
      }else{
        context.read<AppOptions>().style = WidgetStyle.material;
      }
    });
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              print(_workoutList[index]);
              setState(() {
                _selectedWorkout = AppLocalizations.of(context)!.workoutList(_workoutList[index]);
              });
            },
            children: List<Widget>.generate(_workoutList.length, (int index) {
              return Center(
                child: Text(AppLocalizations.of(context)!.workoutList(_workoutList[index])),
              );
            }),
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              _dateTime = newDate;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final appOptions = context.watch<AppOptions>();
    if(appOptions.style == WidgetStyle.cupertino){
      return Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.usedCupertino, style: const TextStyle(fontSize: 14, color: CupertinoColors.black, decoration: TextDecoration.none)),
                  CupertinoSwitch(
                    value: _currentValue ?? false,
                    onChanged: _onStyleChange,
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Center(
                  child: CupertinoButton(
                    onPressed: () => _showCupertinoPicker(context),
                    child: Text(_selectedWorkout??AppLocalizations.of(context)!.selectWorkout),
                  ),
                ),
              ),
              _dropdownError==null? const SizedBox.shrink():Text(_dropdownError!, style: const TextStyle(fontSize: 14,color: Colors.red, decoration:TextDecoration.none)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: CupertinoTextFormFieldRow(
                  prefix: Text(AppLocalizations.of(context)!.duration),
                  keyboardType: TextInputType.number,
                  controller: _durationController,
                  validator: (newValue) {
                    if(newValue == null || newValue.isEmpty) {
                      return AppLocalizations.of(context)!.durationErrorText;
                    }
                    return null;
                  },
                )
              ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(AppLocalizations.of(context)!.selectDate, style: const TextStyle(fontSize: 14, color: CupertinoColors.black, decoration: TextDecoration.none)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: CupertinoButton(
                      onPressed: () => _showDatePicker(context),
                      child: Text(_dateTime.toString().split(" ")[0]),
                    ),
                  )
                ]
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: CupertinoButton.filled(
                  onPressed: _onSavePressed,
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ),
            ],
          ),
        )
      );
    }
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Column(
          children:[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(AppLocalizations.of(context)!.usedCupertino),
                  Checkbox(
                    value: _currentValue??false,
                    onChanged: _onStyleChange,
                  )
                ]
            ),
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
                    return AppLocalizations.of(context)!.durationErrorText;
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
                    return AppLocalizations.of(context)!.dateErrorText;
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
