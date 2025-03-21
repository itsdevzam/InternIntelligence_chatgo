
import 'package:shared_preferences/shared_preferences.dart';

class sharedPref{

  Future<void> setUserData({required String? uid,required String? name,required String? email,required String? username,required String? profileImg})async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('islogin', true);
    await prefs.setString('uid', uid!);
    await prefs.setString('name', name!);
    await prefs.setString('email', email!);
    await prefs.setString('email', email!);
    await prefs.setString('username', username!);
    await prefs.setString('profileImg', profileImg!);
  }

  Future<Map<String, dynamic>> getUserData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? islogin = prefs.getBool('islogin');
    final String? uid = prefs.getString('uid');
    final String? name = prefs.getString('name');
    final String? email = prefs.getString('email');
    final String? username = prefs.getString('username');
    final String? profileImg = prefs.getString('profileImg');
    final Map<String,dynamic> userData = {
      "islogin":islogin,
      "uid":uid,
      "name":name,
      "email":email,
      "username":username,
      "profileImg":profileImg,
    };
    return userData;
  }

  void setLogoutData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('islogin', false);
    await prefs.setString('uid', "");
    await prefs.setString('name', "");
    await prefs.setString('email', "");
    await prefs.setString('username', "");
    await prefs.setString('profileImg', "");
  }

}