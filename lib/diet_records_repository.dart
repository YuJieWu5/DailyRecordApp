import 'diet_record.dart';

abstract class DietRecordsRepository{
  Future<void> addDietRecord(DietRecord record);
  Future<List<DietRecord>> listAllDietRecords();
  Future<void> deleteDietRecord(int id);
  Future<void> updateDietRecord(int id, double quantity);
}