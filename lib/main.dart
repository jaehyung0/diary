import 'package:diary/diary/menu.dart';
import 'package:diary/login/login.dart';
import 'package:diary/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.blueAccent),
        //textTheme: GoogleFonts.sourceSansProTextTheme()
        textTheme: const TextTheme(
          bodyText2: TextStyle(fontFamily: 'Wovud2'),
          headline6: TextStyle(fontFamily: 'Wovud'),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> onWillPop() async {
    return (await context.showConfirmDialog('확인', '앱을 종료하시겠습니까?',
        buttonLabel: '종료'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Menu();
            } else {
              return const Login();
            }
          }),
    );
  }
}
