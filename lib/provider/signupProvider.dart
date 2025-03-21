
import 'package:flutter/foundation.dart';

class signupProvider extends ChangeNotifier{

  bool _imgNull=true;
  bool get isImgNull=>_imgNull;
  //check signup page profile img
  set isImgNull(bool value){
    _imgNull=value;
    notifyListeners();
  }
  //loading btn
  bool _loading=false;
  bool get isloading=>_loading;
  set isSignupLoading(bool value){
    _loading=value;
    notifyListeners();
  }



}