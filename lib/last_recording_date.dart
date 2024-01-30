import 'package:flutter/foundation.dart';

class LastRecordingDate with ChangeNotifier{
  DateTime _lastDate;
  String _recordingType

  LastRecordingDate(this._lastDate, this._recordingType);

  getRecordingDate(){retrun _lastDate;}

  setRecordingDate(DateTime newDate){
    _lastDate = newDate;
    notifyListeners();
  }

  getRecordingType(){return _recordingType};

  setRecordingType(String newType){
    _recordingType = newType;
  }
}