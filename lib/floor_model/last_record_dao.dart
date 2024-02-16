import 'package:floor/floor.dart';
import 'last_record_entity.dart';

@dao
abstract class LastRecordDao{
  @insert
  Future<void> addLastRecord(LastRecordEntity record);

  @Query('SELECT * FROM LastRecord ORDER BY date DESC LIMIT 1')
  Future<LastRecordEntity?> getLastRecord();
  
  @Query('SELECT points FROM LastRecord ORDER BY DESC date LIMIT 1')
  Future<int?> getLastPoints();
}