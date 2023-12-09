import 'package:get/get.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';

class SignupController extends GetxController {
  bool _signUpInProgress = false;
  String _failedmessage = '';

  bool get SignUpInProgress => _signUpInProgress;
  String get failedmessage => _failedmessage;

  Future<bool> signUp(String email, String fastName, String lastName,
      String mobile, String password) async {
    _signUpInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.registration, body: {
      "email": email,
      "firstName": fastName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": '',
    });
    _signUpInProgress = false;
    update();
    if (response.isSuccess) {
      //_failedmessage = 'Account has been created! Please login.';
      return true;
    } else {
      _failedmessage = 'Account creation failed! Please try again';
    }
    return false;
  }
}
