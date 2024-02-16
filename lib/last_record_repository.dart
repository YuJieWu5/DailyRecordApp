import 'last_record.dart';

abstract class LastRecordsRepository{
  Future<void> addLastRecord(LastRecord record);
  Future<LastRecord> getLastRecord();
}