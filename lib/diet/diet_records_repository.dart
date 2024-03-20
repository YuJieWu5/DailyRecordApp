import './diet_record.dart';

abstract class DietRecordsRepository{
  Future<void> addDietRecord(DietRecord record);
  Future<List<DietRecord>> listAllDietRecords();
  Future<void> deleteDietRecord(String id);
  Future<void> updateDietRecord(String id, double quantity);
}