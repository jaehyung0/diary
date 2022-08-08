import 'package:diary/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authentication = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool signUp = false;
  String name = '';

  bool pressEvent() {
    if (signUp) {
      if (email.isEmpty && password.isEmpty && name.isEmpty) {
        return false;
      }
    } else {
      if (email.isEmpty && password.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('이메일 로그인')),
        body: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('이메일', style: TextStyle(fontFamily: 'Wovud2')),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return '이메일을 확인해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('비밀번호', style: TextStyle(fontFamily: 'Wovud2')),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return '비밀번호는 7자 이상입니다.';
                    }
                    return null;
                  },
                ),
                if (signUp) const SizedBox(height: 10),
                if (signUp)
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('이름', style: TextStyle(fontFamily: 'Wovud2')),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: pressEvent()
                          ? () async {
                              if (signUp) {
                                try {
                                  final newUser = await _authentication
                                      .createUserWithEmailAndPassword(
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
                                  print(e);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Please check your email and password'),
                                      backgroundColor: Colors.blue,
                                    ));
                                  }
                                }
                              } else {
                                try {
                                  final newUser = await _authentication
                                      .signInWithEmailAndPassword(
                                          email: email, password: password);
                                  print(newUser);

                                  if (newUser.user != null) {
                                    Get.offAll(() => const MyHomePage());
                                    setState(() {});
                                  }
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Please check your email and password'),
                                    backgroundColor: Colors.blue,
                                  ));
                                }
                              }
                            }
                          : null,
                      child: signUp
                          ? const Text('가입',
                              style: TextStyle(fontFamily: 'Wovud'))
                          : const Text('로그인',
                              style: TextStyle(fontFamily: 'Wovud')),
                    ),
                    Row(
                      children: [
                        const Text('회원가입'),
                        Checkbox(
                            value: signUp,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                signUp = value!;
                              });
                            })
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signInAnonymously();
                  },
                  child: const Text('게스트 로그인'),
                ),
              ],
            ),
          ),
        )));
  }
}
