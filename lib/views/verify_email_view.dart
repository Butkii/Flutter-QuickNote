import 'package:flutter/material.dart';
import 'package:QuickNote/constants/routes.dart';
import 'package:QuickNote/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7EABFF),
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Please check your email for a verification link.'),
          const Text(
              'If you do not receive an email, please press on the button below.'),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email Verification',
                style: TextStyle(color: Color(0XFF2297D7))),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                  (route) {
                return false;
              });
            },
            child: const Text('Restart',
                style: TextStyle(color: Color(0XFF2297D7))),
          )
        ],
      ),
    );
  }
}
