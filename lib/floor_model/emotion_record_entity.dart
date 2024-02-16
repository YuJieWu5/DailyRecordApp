import 'package:floor/floor.dart';

@Entity(tableName: "EmotionRecord")
class EmotionRecordEntity{
  @primaryKey
  final String id;
  final String icon;
  final String emotion;
  final int date;

  EmotionRecordEntity(this.id, this.icon, this.emotion, this.date);
}