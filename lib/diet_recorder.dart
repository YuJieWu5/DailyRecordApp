import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cpsc5250hw/recording_points.dart';
import 'package:cpsc5250hw/last_recording_info.dart';
import 'package:date_field/date_field.dart';


class DietRecorder extends StatefulWidget {
  const DietRecorder({super.key});

  @override
  State<DietRecorder> createState() => _DietRecorder();
}

@visibleForTesting
class _DietRecorder extends State<DietRecorder>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @visibleForTesting
  final List<String> _dietList = [];
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String? _dropdownError;

  void _onSavePressed(){
    print("Food: "+ _foodController.text+ " Quantity: "+_quantityController.text);
    //   _addDirectItem(_foodController.text);
      if (_foodController.text == null || _foodController.text.isEmpty) {
        _dropdownError = 'Food must not be blank.';
        _formKey.currentState?.validate();
        setState(() {});
      } else {
        _dropdownError = null;
        if(_formKey.currentState?.validate()??false){
          context.read<LastRecordingInfo>().setRecordingDate(_dateTime.toString());
          context.read<LastRecordingInfo>().setRecordingType("Diet Record");
          context.read<RecordingPoints>().setRecordingPoints(context.read<RecordingPoints>().getRecordingPoints()+5);
          _formKey.currentState!.reset();
        }

        setState(() {
          if(!_dietList.contains(_foodController.text.toLowerCase()))
            _dietList.add(_foodController.text.toLowerCase());
          _dateTime = DateTime.now();
          _foodController.clear();
          _quantityController.clear();
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
              child: Text('RecordingPoints: ${context.watch<RecordingPoints>().getRecordingPoints()}\t'
                  'Last Update: ${context.watch<LastRecordingInfo>().getRecordingDate()} ${context.watch<LastRecordingInfo>().getRecordingType()}\n'
                  'Diet Record Page',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              )
          ),
        ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Center(
                          child: DropdownMenu<String>(
                            width: 400.0,
                            controller: _foodController,
                            requestFocusOnTap: true,
                            label: const Text('Food'),
                            errorText: _dropdownError,
                            hintText: "Please Enter Food or Select from the DropDownMenu",
                            dropdownMenuEntries: _dietList.map<DropdownMenuEntry<String>>((String food) {
                              return DropdownMenuEntry<String>(
                                value: food,
                                label: food,
                              );
                            }).toList(),
                          )
                      ),
                    ),
                    SizedBox(
                        width: 400.0,
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                              labelText: 'Quantity'
                          ),
                          keyboardType: TextInputType.number,
                          validator: (newValue) {
                            if(newValue == null || newValue.isEmpty) {
                              return 'Quantity must not be blank.';
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
                    )
                  ],
                )
            ),
        )
      )
    );
  }
}
