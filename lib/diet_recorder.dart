import 'package:flutter/material.dart';

class DietRecorder extends StatefulWidget {
  const DietRecorder({super.key});

  @override
  State<DietRecorder> createState() => _DietRecorder();
}

class _DietRecorder extends State<DietRecorder>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _dietList = [];
  String? _foodDropdown;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    _foodController.addListener(_updateState);
  }

  @override
  void dispose(){
    _foodController.removeListener(_updateState);
    _foodController.dispose();
    super.dispose();
  }

  void _updateState(){
    setState(() {
    });
  }

  _addDirectItem(String item){
    if(!_dietList.contains(item.toLowerCase()) && !item.isEmpty){
      setState(() {
        _dietList.add(item.toLowerCase());
        _foodDropdown = null;
        _foodController.clear();
        _quantityController.clear();
      });
    }
  }

  void _onSavePressed(){
    // print("Food: "+ _foodController.text+ " Quantity: "+_quantityController.text);
    if(_foodController.text.isEmpty){
      _addDirectItem(_foodDropdown.toString());
      print(_foodDropdown.toString());
    }
    else
      _addDirectItem(_foodController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("Diet Recorder", style: TextStyle(fontSize: 30),)),
        ),
      body: Form(
        child: SafeArea(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Text('Date: ' + DateTime.now().toString().split(' ')[0], style: TextStyle(fontSize: 20))
                ),
                Center(
                  child: _dietList.isNotEmpty
                      ? DropdownMenu<String>(
                        enabled: _foodController.text.isEmpty,
                        requestFocusOnTap: true,
                        label: const Text('Food'),
                        onSelected: (newValue) => setState(() {
                          if(newValue==null || newValue.isEmpty) _foodDropdown = null;
                          else _foodDropdown = newValue;
                        }),
                        dropdownMenuEntries: _dietList.map<DropdownMenuEntry<String>>((String food) {
                          return DropdownMenuEntry<String>(
                            value: food,
                            label: food,
                          );
                        }).toList(),
                      )
                      : SizedBox.shrink(),
                ),
                  SizedBox(
                    width: 500.0,
                    child: TextFormField(
                      enabled: _foodDropdown==null,
                      controller: _foodController,
                      decoration: const InputDecoration(
                          labelText: 'Food'
                      ),
                      validator:  (newValue) {
                        if(newValue == null || newValue.isEmpty) {
                          return 'Quantity must not be blank.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                      width: 500.0,
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
    );
  }
}
