import 'package:diary/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'email_login.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() async {
    return (await context.showConfirmDialog('확인', '앱을 종료하시겠습니까?',
        buttonLabel: '종료'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signInAnonymously();
                },
                child: const Text('게스트 로그인'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const EmailLogin());
                  },
                  child: const Text('로그인'))
            ],
          ),
        ),
      ),
    );
  }
}
