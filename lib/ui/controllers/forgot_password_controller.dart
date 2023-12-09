import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/screen/pin_verification_screen.dart';

class ForgotPasswordController extends GetxController {
  String _errormessage = '';
  String get errormessage => _errormessage;

  Future<bool> verifyEmail(String email) async {
    final url = Urls.recoverVerifyEmail(email);
    NetworkResponse response = await NetworkCaller().getRequest(url);
    final status = response.jsonResponse['status'] == "success";
    if (response.isSuccess && status) {
      Get.to(PinVerificationScreen(email: email));
      return true;
    } else {
      _errormessage = 'No User Found';
      return false;
    }
  }
}
