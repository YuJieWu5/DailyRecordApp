import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/last_record_entity.dart';
import 'package:cpsc5250hw/last_record_repository.dart';
import 'package:cpsc5250hw/last_record.dart';

class FloorLastRecordRepository implements LastRecordsRepository{
  RecorderDatabase _database;

  FloorLastRecordRepository(this._database);

  @override
  Future<void> addLastRecord(LastRecord record) async{
    // Future<int?> lastPoints = getLastRecordPoints();
    int? lastPoints = await getLastRecordPoints();
    int pointsToBeAdded = (lastPoints??0)+record.points;

    LastRecordEntity entity = LastRecordEntity(
        null,
        record.type,
        record.date.millisecondsSinceEpoch,
        pointsToBeAdded
    );
    print("lastupdate: ${record.type} points: $pointsToBeAdded");
    await _database.lastRecordDao.addLastRecord(entity);
  }

  @override
  Future<LastRecord> getLastRecord() async{
    final entity = await _database.lastRecordDao.getLastRecord();
    // print("getLastRecord type:${entity!.type}");
    // LastRecord record =_covertFromDatabase(entity!);
    return _covertFromDatabase(entity!);
  }

  @override
  Future<int?> getLastRecordPoints() async{
    return await _database.lastRecordDao.getLastPoints();
  }

  LastRecord _covertFromDatabase(LastRecordEntity entity) => LastRecord(
      entity.type,
      DateTime.fromMillisecondsSinceEpoch(entity.date),
      entity.points
  );
}