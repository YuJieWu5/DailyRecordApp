import 'package:floor/floor.dart';

@Entity(tableName: "LastRecord")
class LastRecordEntity{
  @primaryKey
  final String? id;
  final String type;
  final int date;
  final int points;

  LastRecordEntity(this.id, this.type, this.date, this.points);
}