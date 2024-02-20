import 'package:cpsc5250hw/last_record.dart';
import 'package:cpsc5250hw/last_record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'emotion_record.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:cpsc5250hw/emotion_records_view_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cpsc5250hw/app_options.dart';

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
  String? _selectedEmotion;
  String? _selectedIcon;
  bool? _currentValue;
  var uuid = Uuid();

  void _onSavePressed(){
    print("User selected " + _emotionController.text + " emotion and pressed save!");
    if((_emotionController.text == null || _emotionController.text.isEmpty) && _selectedEmotion==null){
      _dropdownError = AppLocalizations.of(context)!.emotionErrorText;
      _formKey.currentState?.validate();
      setState(() {});
    } else{
      _dropdownError = null;
      setState(() {});
      if(_formKey.currentState?.validate()??false){
        EmotionRecord record = EmotionRecord(
            uuid.v4(),
            _selectedIcon??_emotionController.text.split(' ')[1],
            _selectedEmotion==null?_emotionController.text.split(' ')[0]:_selectedEmotion!.split(' ')[0],
            _dateTime
        );
        LastRecord lastRecord = LastRecord("Emotion Record", DateTime.now(),1);
        context.read<EmotionRecordsViewModel>().addEmotionRecord(record);
        context.read<LastRecordViewModel>().addLastRecord(lastRecord);
        _emotionController.clear();
        _formKey.currentState!.reset();
      }
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

  void _showCupertinoPickerForEmotion(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          color: CupertinoColors.white,
          child: CupertinoPicker(
            backgroundColor: CupertinoColors.white,
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedEmotion = AppLocalizations.of(context)!.emotionList(
                    EmotionMenu.values[index].key) + " " +
                    EmotionMenu.values[index].value;
                // _selectedEmotion = EmotionMenu.values[index].key;
                _selectedIcon = EmotionMenu.values[index].value;
                print("Emotion: $_selectedEmotion IconOnly: $_selectedIcon");
              });
            },
            children: EmotionMenu.values.map((emotion) {
              return Center(
                child: Text("${AppLocalizations.of(context)!.emotionList(
                    emotion.key)} ${emotion.value}"),
              );
            }).toList(),
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
  Widget build(BuildContext context) {
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
                      onPressed: () => _showCupertinoPickerForEmotion(context),
                      child: Text(_selectedEmotion??AppLocalizations.of(context)!.selectEmotion),
                    ),
                  ),
                ),
                _dropdownError==null? const SizedBox.shrink():Text(_dropdownError!, style: const TextStyle(fontSize: 14,color: Colors.red, decoration:TextDecoration.none)),
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
              children: [
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
                  )
                ),
              ],
            ),
          )
      );
  }
}
