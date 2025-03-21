

import 'package:chatgo/helper/sharedPref.dart';
import 'package:flutter/cupertino.dart';

class profileProvider extends ChangeNotifier{

  Map<String, dynamic> _userData={};
  Map<String, dynamic> get ProfileuserData => _userData;

  void loadUserData()async{
    _userData = await sharedPref().getUserData();
    notifyListeners();
  }
}