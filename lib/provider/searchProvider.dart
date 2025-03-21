

import 'package:flutter/cupertino.dart';

class searchProvider extends ChangeNotifier{
  bool _isLoading = false;
  bool get isloading => _isLoading;

  void setLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }



}