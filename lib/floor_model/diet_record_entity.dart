import 'package:floor/floor.dart';

@Entity(tableName: "DietRecord")
class DietRecordEntity{
  @primaryKey
  final String id;
  final String food;
  final double quantity;
  final int date;

  DietRecordEntity(this.id, this.food, this.quantity, this.date);
}