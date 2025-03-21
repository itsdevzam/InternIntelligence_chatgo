

import 'package:chatgo/helper/sharedPref.dart';
import 'package:flutter/cupertino.dart';

class settingScreenProvider extends ChangeNotifier{

  Map<String, dynamic> _userData={};
  Map<String, dynamic> get SettinguserData => _userData;

  void loadUserData()async{
    _userData = await sharedPref().getUserData();
    notifyListeners();
  }

}