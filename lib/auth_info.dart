import 'package:flutter/foundation.dart';

class AuthInfo with ChangeNotifier{
  String? _id;
  String? _email;
  AuthInfo(this._id, this._email);

  String? getUserId(){
    return _id;
  }

  String? getUserEmail(){
    return _email;
  }

  void setUserId(String id){
    _id = id;
    notifyListeners();
  }

  void setUserEmail(String email){
    _email = email;
    notifyListeners();
  }
}