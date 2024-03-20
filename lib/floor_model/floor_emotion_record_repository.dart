import 'package:cpsc5250hw/floor_model/recorder_database.dart';
import 'package:cpsc5250hw/floor_model/emotion_record_entity.dart';
import 'package:cpsc5250hw/emotion/emotion_records_repository.dart';
import 'package:cpsc5250hw/emotion/emotion_record.dart';

class FloorEmotionRecordsRepository implements EmotionRecordsRepository{
  RecorderDatabase _database;

  FloorEmotionRecordsRepository(this._database);

  @override
  Future<void> addEmotionRecord(EmotionRecord record) async{
    EmotionRecordEntity entity = EmotionRecordEntity(
        record.id,
        record.icon,
        record.emotion,
        record.date.millisecondsSinceEpoch
    );
    await _database.emotionRecordDao.addEmotionRecord(entity);
  }

  @override
  Future<void> deleteEmotionRecord(String id) async{
    await _database.emotionRecordDao.deleteEmotionRecord(id);
  }

  @override
  Future<List<EmotionRecord>> listAllEmotionRecords() async{
    final entities = await _database.emotionRecordDao.listAllEmotionRecord();
    return entities.map(_covertFromDatabase).toList();
  }

  EmotionRecord _covertFromDatabase(EmotionRecordEntity entity) => EmotionRecord(
      entity.id,
      entity.icon,
      entity.emotion,
      DateTime.fromMillisecondsSinceEpoch(entity.date)
  );
}