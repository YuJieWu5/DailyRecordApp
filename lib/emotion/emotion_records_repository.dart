import 'emotion_record.dart';

abstract class EmotionRecordsRepository{
  Future<void> addEmotionRecord(EmotionRecord record);
  Future<List<EmotionRecord>> listAllEmotionRecords();
  Future<void> deleteEmotionRecord(String id);
}