import 'package:diary/login/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  String name = '';

  bool pressEvent() {
    if ((email.isEmpty || password.isEmpty) && name.isEmpty) {
      return false;
    }
    return true;
  }

  late LoginProvider _loginProvider;

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: const Text('이메일 로그인')),
        body: ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        label:
                            Text('이메일', style: TextStyle(fontFamily: 'Wovud2')),
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
                        label: Text('비밀번호',
                            style: TextStyle(fontFamily: 'Wovud2')),
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return '비밀번호는 7자 이상입니다.';
                        }
                        return null;
                      },
                    ),
                    if (_loginProvider.check) const SizedBox(height: 10),
                    if (_loginProvider.check)
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('이름',
                              style: TextStyle(fontFamily: 'Wovud2')),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
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
                                  if (_loginProvider.check) {
                                    _loginProvider.signUp(
                                        email, password, name);
                                  } else {
                                    _loginProvider.login(email, password);
                                  }
                                }
                              : null,
                          child: _loginProvider.check
                              ? const Text('가입',
                                  style: TextStyle(fontFamily: 'Wovud'))
                              : const Text('로그인',
                                  style: TextStyle(fontFamily: 'Wovud')),
                        ),
                        Row(
                          children: [
                            const Text('회원가입'),
                            Checkbox(
                                value: _loginProvider.check,
                                onChanged: (value) {
                                  _loginProvider.changeInUp(value!);
                                  setState(() {});
                                  //_loginProvider.changeInUp(value!);
                                })
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                          onPressed: () {
                            FirebaseAuth.instance.signInAnonymously();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('게스트',
                                style: TextStyle(
                                    fontSize: 30, fontFamily: 'wovud')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
