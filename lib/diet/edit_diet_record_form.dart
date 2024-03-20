import 'package:cpsc5250hw/diet_record.dart';
import 'package:cpsc5250hw/diet_records_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditDietRecordForm extends StatefulWidget {
  final DietRecord dietRecord;
  const EditDietRecordForm(this.dietRecord, {super.key});

  @override
  createState() => _EditDietRecordFormState();
}

class _EditDietRecordFormState extends State<EditDietRecordForm> {
  TextEditingController _quantityController = TextEditingController();
  // final DietRecord _dietRecord = context.;

  @override
  initState() {
    super.initState();
    print('initializing bank balance form');
    // _balanceController.text = '${context.read<Edi>().getBalance()}';
    _quantityController = TextEditingController(text: widget.dietRecord.quantity.toString());
  }

  _onSave() {
    double newQuantity = double.parse(_quantityController.text);
    print('updating bank balance to $newQuantity');
    context.read<DietRecordsViewModel>().updateDietRecord(widget.dietRecord.id, newQuantity);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dietRecord = widget.dietRecord;
    return Column(
        children: <Widget>[
          Text('${dietRecord.food}'),
          Text('${dietRecord.date.toString().split(' ')[0]}'),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _onSave,
            child: const Text('Save'),
          )
        ]
    );
  }
}
