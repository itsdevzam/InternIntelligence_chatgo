import 'package:chatgo/services/auth/authServices.dart';
import 'package:chatgo/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class forgotPassHelper {
  TextEditingController emailController;
  BuildContext context;
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  forgotPassHelper({
    required TextEditingController this.emailController,
    required BuildContext this.context,
  });

  void sendforgotPass() {
    utils.customPrint("Forgot Password Start");
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(emailController.text)) {
      utils.showToast(context: context, msg: "Please enter a valid email");
    } else {
      try {
        authServices().forgotPassword(
          email: emailController.text,
          context: context,
        );
      } catch (e) {
        utils.customPrint(e);
      }
      utils.customPrint("Forgot Password end");
    }
  }
}
