import 'package:floor/floor.dart';
import 'emotion_record_entity.dart';

@dao
abstract class EmotionRecordDao{
  @insert
  Future<void> addEmotionRecord(EmotionRecordEntity record);
  @Query('SELECT * FROM EmotionRecord')
  Future<List<EmotionRecordEntity>> listAllEmotionRecord();
  @Query('DELETE FROM EmotionRecord WHERE id = :id')
  Future<void> deleteEmotionRecord(String id);
}