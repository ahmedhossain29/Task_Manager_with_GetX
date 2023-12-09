import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/screen/set_password_screen.dart';

class PinVerificationController extends GetxController {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> verifyPin(String email, String pin) async {
    final pinVerify = Urls.pinVerification(email, pin);
    NetworkResponse response = await NetworkCaller().getRequest(pinVerify);
    final status = response.jsonResponse['status'] == "success";
    if (response.isSuccess && status) {
      Get.to(SetPasswordScreen(
        email: email,
        pin: pin,
      ));
    } else {
      _errorMessage = 'Invalid OTP Code';
    }
  }
}
