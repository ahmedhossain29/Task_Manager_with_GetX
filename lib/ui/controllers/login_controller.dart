import 'package:get/get.dart';

import '../../data_network_caller/models/user_model.dart';
import '../../data_network_caller/network_caller.dart';
import '../../data_network_caller/network_response.dart';
import '../../data_network_caller/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;

  String _failedmessage = '';

  bool get loginInProgress => _loginInProgress;
  String get failedMessage => _failedmessage;

  Future<bool> login(String email, String password) async {
    _loginInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {
          'email': email,
          'password': password,
        },
        isLogin: true);
    _loginInProgress = false;
    update();
    if (response.isSuccess) {
      await Get.find<AuthController>().saveUserInformation(
          response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));
      return true;
    } else {
      if (response.statusCode == 401) {
        _failedmessage = 'Please check email or password';
      } else {
        _failedmessage = 'Login failed. Try again';
      }
    }
    return false;
  }
}
