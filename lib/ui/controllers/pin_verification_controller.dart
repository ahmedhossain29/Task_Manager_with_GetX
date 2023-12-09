import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/screen/set_password_screen.dart';

class PinVerificationController extends GetxController {
  String _errorMessage = '';
  String _doneMessage = '';
  String get errorMessage => _errorMessage;
  String get DoneMessage => _doneMessage;

  Future<void> verifyPin(String email, String pin) async {
    final pinVerify = Urls.pinVerification(email, pin);
    NetworkResponse response = await NetworkCaller().getRequest(pinVerify);
    final status = response.jsonResponse['status'] == "success";
    if (response.isSuccess && status) {
      Get.to(SetPasswordScreen(
        email: email,
        pin: pin,
      ));
      _doneMessage = "OTP Verify";
    } else {
      _errorMessage = 'Invalid OTP Code';
    }
  }
}
