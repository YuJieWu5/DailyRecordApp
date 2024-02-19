import 'package:cpsc5250hw/last_record.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:flutter/material.dart';
import 'emotion_record.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:cpsc5250hw/emotion_records_view_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum EmotionMenu {
  happy('happy', '😆'),
  joyful('joyful', '🥳'),
  good('good','😀'),
  love('love','🥰'),
  grateful('grateful', '😍'),
  excited('excited', '🤩'),
  anxious('anxious', '😖'),
  confident('confident','😎'),
  surprised('surprised', '😳'),
  amused('amused', '🤣'),
  bored('bored','😶'),
  curious('curious', '🤔'),
  disgusted('disgusted', '🤮'),
  frustrated('frustrated', '😞'),
  envious('envious', '🥺'),
  inquisitive('inquisitive', '😮'),
  tense('tense', '😬'),
  lonely('lonely', '😔'),
  angry('angry', '😡'),
  sad('sad', '😢'),
  fear('fear', '😨'),
  weary('weary','😩'),
  expressionless('expressionless', '😑'),
  sick('sick', '🤒');

  const EmotionMenu(this.key, this.value);
  final String key;
  final String value;
}

class EmotionRecordForm extends StatefulWidget {
  const EmotionRecordForm({super.key});

  @override
  createState() => _EmotionRecordState();
}

class _EmotionRecordState extends State<EmotionRecordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emotionController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  String? _dropdownError;
  var uuid = Uuid();

  void _onSavePressed(){
    print("User selected " + _emotionController.text + " emotion and pressed save!");
    if(_emotionController.text == null || _emotionController.text.isEmpty){
      _dropdownError = 'Emotion must not be blank.';
      _formKey.currentState?.validate();
      setState(() {});
    } else{
      _dropdownError = null;
      setState(() {});
      if(_formKey.currentState?.validate()??false){
        EmotionRecord record = EmotionRecord(
            uuid.v4(),
            _emotionController.text.split(' ')[1],
            _emotionController.text.split(' ')[0],
            _dateTime
        );
        LastRecord lastRecord = LastRecord("Emotion Record", DateTime.now(),1);
        context.read<EmotionRecordsViewModel>().addEmotionRecord(record);
        // context.read<LastRecordingInfo>().setRecordingDate(_dateTime.toString());
        // context.read<LastRecordingInfo>().setRecordingType("Emotion Record");
        context.read<LastRecordViewModel>().addLastRecord(lastRecord);
        // context.read<RecordingPoints>().setRecordingPoints();
        _emotionController.clear();
        _formKey.currentState!.reset();
      }
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
                      child: DropdownMenu<EmotionMenu>(
                        width: 400.0,
                        requestFocusOnTap: false,
                        errorText: _dropdownError,
                        label: Text(AppLocalizations.of(context)!.emotion),
                        controller: _emotionController,
                        dropdownMenuEntries: EmotionMenu.values
                            .map<DropdownMenuEntry<EmotionMenu>>(
                                (EmotionMenu emotion){
                              return DropdownMenuEntry<EmotionMenu>(
                                value: emotion,
                                label: "${AppLocalizations.of(context)!.emotionList(emotion.key)} ${emotion.value}",
                              );
                            }).toList(),
                      ),
                    ),
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
                    )
                  ),
                ],
              ),
            )
        );
  }
}
