import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/diet_record_entity.dart';
import 'package:cpsc5250hw/diet/diet_records_repository.dart';
import 'package:cpsc5250hw/diet/diet_record.dart';
import 'package:uuid/uuid.dart';

class FloorDietRecordsRepository implements DietRecordsRepository{
  RecorderDatabase _database;
  var uuid = Uuid();

  FloorDietRecordsRepository(this._database);

  @override
  Future<void> addDietRecord(DietRecord record) async{
    DietRecordEntity entity = DietRecordEntity(
        record.id,
        record.food,
        record.quantity,
        record.date.millisecondsSinceEpoch
    );
    await _database.dietRecordDao.addDietRecord(entity);
  }

  @override
  Future<void> deleteDietRecord(String id) async{
    await _database.dietRecordDao.deleteDietRecord(id);
  }

  @override
  Future<List<DietRecord>> listAllDietRecords() async{
    final entities = await _database.dietRecordDao.listAllDietRecord();
    return entities.map(_covertFromDatabase).toList();
  }

  @override
  Future<void> updateDietRecord(String id, double quantity)async{
    await _database.dietRecordDao.updateDietRecord(id, quantity);
  }

  DietRecord _covertFromDatabase(DietRecordEntity entity) => DietRecord(
      entity.id,
      entity.food,
      entity.quantity,
      DateTime.fromMillisecondsSinceEpoch(entity.date)
  );
}