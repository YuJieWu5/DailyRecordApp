import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../auth_info.dart';
import '../last_record.dart';
import '../last_record_view_model.dart';
import '../recording_points_dao.dart';
import './workout_record.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/workout/workout_records_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:uuid/uuid.dart';
import 'package:cpsc5250hw/app_options.dart';
import 'package:cpsc5250hw/language_options.dart';

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
  bool? _isUsingCupertino;
  bool? _isZh;
  DateTime _dateTime = DateTime.now();
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _isUsingCupertino = context.read<AppOptions>().style == WidgetStyle.cupertino? true: false;
    _isZh = context.read<LocaleProvider>().locale == Locale('en')? false : true;
  }

  void _onSavePressed(){
    print("Workout: "+ _workoutController.text+ " Quantity: "+_durationController.text);
    if ((_workoutController.text == null || _workoutController.text.isEmpty) && _selectedWorkout==null) {
      _dropdownError = AppLocalizations.of(context)!.workoutErrorText;
      _formKey.currentState?.validate();
      setState(() {});
    } else {
      _dropdownError = null;
      if(_formKey.currentState?.validate()??false){
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
        _updateFirestorePoints();
      }
      setState(() {
        _dateTime = DateTime.now();
        _durationController.clear();
        _workoutController.clear();
      });
    }
  }

  Future<void> _updateFirestorePoints() async {
    var userId = context.read<AuthInfo>().getUserId();

    if (userId == null) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        userId = user.uid;
        context.read<AuthInfo>().setUserId(user.uid);
        context.read<AuthInfo>().setUserEmail(user.email!);
      } else {
        print("No user is signed in.");
        return Future.value();
      }
    }

    // print(userId);

    try {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable callable = functions.httpsCallableFromUrl("https://updatepoints-ogagcsc63a-uc.a.run.app/updatePoints?UserID=$userId");
      final result = await callable.call();
      print("Function result: ${result.data}");
    } catch (e) {
      print("Error calling function: $e");
    }
  }


  void _onStyleChange(bool? newValue){
    setState(() {
      _isUsingCupertino = newValue;
      if(_isUsingCupertino!){
        context.read<AppOptions>().style = WidgetStyle.cupertino;
      }else{
        context.read<AppOptions>().style = WidgetStyle.material;
      }
    });
  }

  void _onLocaleChange(bool? newValue){
    setState(() {
      _isZh = newValue;
      if(_isZh!){
        context.read<LocaleProvider>().setLocale(Locale('zh'));
      }else{
        context.read<LocaleProvider>().setLocale(Locale('en'));
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
                  Text(AppLocalizations.of(context)!.en, style: const TextStyle(fontSize: 14, color: CupertinoColors.black, decoration: TextDecoration.none)),
                  CupertinoSwitch(
                    value: _isZh ?? false,
                    onChanged: _onLocaleChange,
                  ),
                  Text(AppLocalizations.of(context)!.zh, style: const TextStyle(fontSize: 14, color: CupertinoColors.black, decoration: TextDecoration.none)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.usedCupertino, style: const TextStyle(fontSize: 14, color: CupertinoColors.black, decoration: TextDecoration.none)),
                  CupertinoSwitch(
                    value: _isUsingCupertino ?? false,
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
                  Text(AppLocalizations.of(context)!.en),
                  Switch(
                    value: _isZh??false,
                    onChanged: _onLocaleChange,
                  ),
                  Text(AppLocalizations.of(context)!.zh),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(AppLocalizations.of(context)!.usedCupertino),
                  Switch(
                    value: _isUsingCupertino??false,
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
