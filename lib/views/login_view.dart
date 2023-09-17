import 'package:QuickNote/utilities/changeTheme.dart';
import 'package:flutter/material.dart';
import 'package:QuickNote/services/auth/auth_exceptions.dart';
import 'package:QuickNote/services/auth/auth_service.dart';
import 'package:QuickNote/utilities/dialogs/error_dialog.dart';
import 'package:QuickNote/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool passwordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    passwordVisible = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeMode == ThemeMode.light
            ? const Color(0xFF7EABFF)
            : const Color.fromARGB(255, 25, 33, 49),
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150.0,
            width: 150.0,
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0XFF817C7A),
                  ),
                ),
                labelText: 'Email',
                hintText: 'someone@example.com',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _password,
              obscureText: passwordVisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0XFF817C7A),
                  ),
                ),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xFF7EABFF),
            ),
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    //user's email is verified
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    //user's email is not verified
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong credentials',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication Error',
                  );
                }
              },
              child: const Text(
                'Log In',
                style: TextStyle(color: Color(0XFFF4EFEA)),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //forgot password route
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: Color(0XFF2297D7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text(
              'Not registered? Register here!',
              style: TextStyle(
                color: Color(0XFF2297D7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
