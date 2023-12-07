import 'package:flutter/material.dart';

import '../../data_network_caller/network_caller.dart';
import '../../data_network_caller/network_response.dart';
import '../../data_network_caller/utility/urls.dart';
import '../widgets/body_background.dart';
import '../widgets/snack_message.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;
  final String pin;

  const SetPasswordScreen({super.key, required this.email, required this.pin});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Minimum password length should be more then 8 characters',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: setPassword, child: const Text('Confirm')),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //set password
  Future<void> setPassword() async {
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
      "email": widget.email,
      "OTP": widget.pin,
      "password": _confirmPasswordTEController.text,
    });
    print(response.jsonResponse);
    final status = response.jsonResponse['status'] == "success";
    if (response.isSuccess && status) {
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        if (mounted) {
          showSnackMessage(context, 'Invalid Request');
        }
      }
    }
  }
}
