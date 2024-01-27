import 'package:flutter/material.dart';
import 'emotion_record.dart';

enum EmotionMenu {
  happy('happy', '😆'),
  joyful('joyful', '🥳'),
  good('good','😀'),
  love('love','🥰'),
  gateful('grateful', '😍'),
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
  final void Function(EmotionRecord record) addEmotionRecord;
  const EmotionRecordForm(this.addEmotionRecord, {super.key});

  @override
  createState() => _EmotionRecordState();
}

class _EmotionRecordState extends State<EmotionRecordForm>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emotionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _onSavePressed(){
    print("User selected " + _emotionController.text + " emotion and pressed save!");
    if(_formKey.currentState?.validate()??false){
      EmotionRecord record = new EmotionRecord(
          _emotionController.text.split(' ')[1],
          _emotionController.text.split(' ')[0],
          DateTime.now()
      );
      _dateController.clear();
      _emotionController.clear();
      widget.addEmotionRecord(record);
      _formKey.currentState!.reset();
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
                    child: Text('Date: ' + DateTime.now().toString().split(' ')[0], style: TextStyle(fontSize: 20))
                  ),
                  Center(
                    child: DropdownMenu<EmotionMenu>(
                      width: 300.0,
                      requestFocusOnTap: false,
                      label: const Text('Emotion'),
                      controller: _emotionController,
                      dropdownMenuEntries: EmotionMenu.values
                          .map<DropdownMenuEntry<EmotionMenu>>(
                              (EmotionMenu emotion){
                            return DropdownMenuEntry<EmotionMenu>(
                              value: emotion,
                              label: emotion.key+" "+emotion.value,
                            );
                          }).toList(),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Date'
                    ),
                    keyboardType: TextInputType.datetime,
                    controller: _dateController,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        onPressed: _onSavePressed,
                        child: const Text('Save')
                    )
                  ),
                ],
              ),
            )
        );
  }
}
