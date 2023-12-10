import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanagerwithgetx/ui/controllers/update_profile_controller.dart';

import '../controllers/auth_controller.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_widget.dart';
import '../widgets/snack_message.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formlKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  final UpdateProfileController _updateProfileController =
      Get.find<UpdateProfileController>();

  //XFile? photo;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = authController.user?.email ?? '';
    _firstNameTEController.text = authController.user?.firstName ?? '';
    _lastNameTEController.text = authController.user?.lastName ?? '';
    _mobileTEController.text = authController.user?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add form validation
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(
              enableOnTap: false,
            ),
            Form(
              key: _formlKey,
              child: Expanded(
                child: BodyBackground(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Update Profile',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          photoPickerField(),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _emailTEController,
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _firstNameTEController,
                            decoration:
                                const InputDecoration(hintText: 'First name'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _lastNameTEController,
                            decoration:
                                const InputDecoration(hintText: 'Last name'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _mobileTEController,
                            decoration:
                                const InputDecoration(hintText: 'Mobile'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your mobile number';
                              }
                              if (value!.length < 10) {
                                return 'Enter your valid mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _passwordTEController,
                            decoration: const InputDecoration(
                                hintText: 'Password (optional)'),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: GetBuilder<UpdateProfileController>(
                                builder: (updateProfileController) {
                              return Visibility(
                                visible: updateProfileController
                                        .updateProfileInProgress ==
                                    false,
                                replacement: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                child: ElevatedButton(
                                  onPressed: updateProfile,
                                  child: const Icon(
                                      Icons.arrow_circle_right_outlined),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (!_formlKey.currentState!.validate()) {
      return;
    }

    final response = await _updateProfileController.updateProfile(
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _emailTEController.text.trim(),
        _mobileTEController.text.trim(),
        _passwordTEController.text.trim());

    _updateProfileController.updateProfileInProgress;
    if (mounted) {
      showSnackMessage(context, _updateProfileController.message);
    } else {
      if (mounted) {
        showSnackMessage(context, _updateProfileController.errormessage);
      }
    }
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final XFile? image = await ImagePicker()
                    .pickImage(source: ImageSource.camera, imageQuality: 50);
                if (image != null) {
                  _updateProfileController.photo = image;
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Visibility(
                  visible: _updateProfileController.photo == null,
                  replacement: Text(_updateProfileController.photo?.name ?? ''),
                  child: const Text('Select a photo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
