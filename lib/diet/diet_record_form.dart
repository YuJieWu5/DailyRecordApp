import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cpsc5250hw/diet/diet_record.dart';
import 'package:cpsc5250hw/diet/diet_records_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:uuid/uuid.dart';
import '../auth_info.dart';
import '../last_record.dart';
import '../last_record_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../recording_points_dao.dart';


class DietRecordForm extends StatefulWidget {
  const DietRecordForm({super.key});

  @override
  State<DietRecordForm> createState() => _DietRecordForm();
}

class _DietRecordForm extends State<DietRecordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _dietList = [];
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String? _dropdownError;
  var uuid = Uuid();

  void _onSavePressed(){
    print("Food: "+ _foodController.text+ " Quantity: "+_quantityController.text);
    //   _addDirectItem(_foodController.text);
      if (_foodController.text == null || _foodController.text.isEmpty) {
        _dropdownError = AppLocalizations.of(context)!.foodErrorText;
        _formKey.currentState?.validate();
        setState(() {});
      } else {
        _dropdownError = null;
        if(_formKey.currentState?.validate()??false){
          DietRecord record = DietRecord(
              uuid.v4(),
              _foodController.text,
              double.parse(_quantityController.text),
              _dateTime
          );
          LastRecord lastRecord = LastRecord("Diet Record", DateTime.now(),5);
          context.read<DietRecordsViewModel>().addDietRecord(record);
          context.read<LastRecordViewModel>().addLastRecord(lastRecord);

          _formKey.currentState!.reset();
          _updateFirestorePoints();
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

  @override
  Widget build(BuildContext context) {
    return Form(
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
                            label: Text(AppLocalizations.of(context)!.food),
                            errorText: _dropdownError,
                            hintText: AppLocalizations.of(context)!.foodHintText,
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
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.quantity
                          ),
                          keyboardType: TextInputType.number,
                          validator: (newValue) {
                            if(newValue == null || newValue.isEmpty) {
                              return AppLocalizations.of(context)!.quantityErrorText;
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
                    )
                  ],
                )
            ),
    );
  }
}
