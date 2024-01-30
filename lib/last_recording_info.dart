import 'package:flutter/foundation.dart';

class LastRecordingInfo with ChangeNotifier{
  String _lastDate;
  String _recordingType;

  LastRecordingInfo(this._lastDate, this._recordingType);

  getRecordingDate(){ return _lastDate; }

  setRecordingDate(String newDate){
    _lastDate = newDate;
    notifyListeners();
  }

  getRecordingType(){ return _recordingType; }

  setRecordingType(String newType){
    _recordingType = newType;
  }
}