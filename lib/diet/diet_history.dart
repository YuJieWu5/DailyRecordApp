import 'package:cpsc5250hw/diet/edit_diet_record_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../diet/diet_record.dart';
import 'package:cpsc5250hw/diet/diet_records_view_model.dart';

class DietHistory extends StatefulWidget {
  const DietHistory({super.key});

  @override
  createState() => _DietHistory();
}

class _DietHistory extends State<DietHistory> {

  void _onDeletePressed(String id){
    context.read<DietRecordsViewModel>().deleteDietRecord(id);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<DietRecord>> futureDeitRecords = context.select<
        DietRecordsViewModel,
        Future<List<DietRecord>>>(
            (viewModel) => viewModel.listAllDietRecords()
    );
    return FutureBuilder(
        future: futureDeitRecords,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dietRecords = snapshot.data!;
            return Column(
              children: dietRecords.map((record) =>
                  ListTile(
                    leading: Text(record.food),
                    title: Text('${record.quantity.toString()}'),
                    subtitle: Text('${record.date.toString().split(' ')[0]}'),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context){
                                    return EditDietRecordForm(record);
                                  }
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: (){
                              _onDeletePressed(record.id);
                            },
                          ),
                        ],
                    )



                  )).toList(),
            );
          } else if (snapshot.hasError) {
            return const Text(
                'An error occurred trying to load your data and we have no idea what to do about it. Sorry.');
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}
