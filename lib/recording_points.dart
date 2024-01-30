import 'package:flutter/foundation.dart';

class RecordingPoints with ChangeNotifier{
  int _points;

  RecordingPoints(this._points);

  int getRecordingPoints(){
    return _points;
  }

  void setRecordingPoints(int newValue){
    _points = newValue;
    notifyListeners();
  }
}