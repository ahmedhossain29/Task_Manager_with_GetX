import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanagerwithgetx/data_network_caller/models/user_model.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_caller.dart';
import 'package:taskmanagerwithgetx/data_network_caller/network_response.dart';
import 'package:taskmanagerwithgetx/data_network_caller/utility/urls.dart';
import 'package:taskmanagerwithgetx/ui/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  String _message = "";
  String _errormessage = "";

  String get message => _message;
  String get errormessage => _errormessage;

  XFile? photo;

  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;

  Future<void> updateProfile(String fastName, String lastName, String email,
      String mobile, String password) async {
    _updateProfileInProgress = true;
    update();
    String? photoInBase64;
    Map<String, dynamic> inputData = {
      "firstName": fastName,
      "lastName": lastName,
      "email": email,
      "mobile": mobile,
      "password": password,
    };

    if (photo != null) {
      List<int> imageBytes = await photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoInBase64;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(
      Urls.updateProfile,
      body: inputData,
    );
    _updateProfileInProgress = false;
    update();
    if (response.isSuccess) {
      Get.find<AuthController>().updateUserInformation(UserModel(
          email: email,
          firstName: fastName,
          lastName: lastName,
          mobile: mobile,
          photo: photoInBase64 ?? Get.find<AuthController>().user?.photo));
      _message = 'Update profile success!';
      update();
    } else {
      _errormessage = 'Update profile failed. Try again.';
    }
  }
}
