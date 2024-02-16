import 'package:floor/floor.dart';
import 'diet_record_entity.dart';

@dao
abstract class DietRecordDao{
  @insert
  Future<void> addDietRecord(DietRecordEntity record);

  @Query('SELECT * FROM DietRecord')
  Future<List<DietRecordEntity>> listAllDietRecord();

  @Query('DELETE FROM DietRecord WHERE id = :id')
  Future<void> deleteDietRecord(String id);

  @Query('UPDATE DietRecord SET quantity = :quantity WHERE id = :id')
  Future<void> updateDietRecord(String id, double quantity);
}