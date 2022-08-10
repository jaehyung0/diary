import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LoginProvider extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;

  void signUp(String email, String password, String name) async {
    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
          email: email, password: password);

      //firebase datastore에 user정보 등록하는 법법
      await FirebaseFirestore.instance
          .collection('user')
          .doc(newUser.user!.uid)
          .set({
        'userName': name,
        'email': email,
      });
      Get.snackbar('회원가입', '회원가입이 완료되었습니다.');
    } catch (e) {
      Get.snackbar('에러', '회원가입 에러');
    }

    notifyListeners();
  }

  void login(String email, String pw) async {
    try {
      final newUser = await _authentication.signInWithEmailAndPassword(
          email: email, password: pw);
      if (newUser.user != null) {
        Get.offAll(() => const MyHomePage());
      }
    } catch (e) {
      print(e);
      Get.snackbar('에러', '로그인 에러');
    }
    notifyListeners();
  }

  bool _check = false;
  bool get check => _check;
  void changeInUp(bool value) {
    _check = value;
    notifyListeners();
  }
}
