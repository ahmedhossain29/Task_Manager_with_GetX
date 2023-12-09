import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/screen/login_screen.dart';

class SetPasswordController extends GetxController {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> setPassword(String email, String password, String pin) async {
    // void checkPassword() {
    //   String enteredPassword = _passwordTEController.text.trim();
    //   String confirmPassword = _confirmPasswordTEController.text.trim();
    //   if (enteredPassword == confirmPassword) {
    //     setState(() {
    //       password = enteredPassword;
    //     });
    //   } else {
    //     print('Passwords do not match. Please try again.');
    //   }
    // }

    NetworkResponse response =
        await NetworkCaller().postRequest(Urls.setPassword, body: {
      "email": email,
      "OTP": pin,
      "password": password,
    });
    //print(response.jsonResponse);
    final status = response.jsonResponse['status'] == "success";
    if (response.isSuccess && status) {
      Get.to(const LoginScreen());
    } else {
      _errorMessage = 'Invalid Request';
    }
  }
}
