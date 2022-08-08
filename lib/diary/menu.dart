import 'package:diary/main.dart';
import 'package:diary/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diary.dart';
import 'diarylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _authentication = FirebaseAuth.instance;

  String getName(List<QueryDocumentSnapshot<Map<String, dynamic>>> userInfo) {
    String name = '';
    for (int i = 0; i < userInfo.length; i++) {
      if (userInfo[i].data()['email'] == _authentication.currentUser!.email) {
        name = userInfo[i].data()['userName'] ?? '';
      }
    }
    return name;
  }

  Future<bool> onWillPop() async {
    return (await context.showConfirmDialog('확인', '앱을 종료하시겠습니까?',
        buttonLabel: '종료'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final userInfo = snapshot.data!.docs;
            String name = '게스트';
            if (userInfo.isNotEmpty) {
              name = getName(userInfo);
            }
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/beach.jpg'))),
              child: Scaffold(
                appBar: AppBar(title: Text('$name의 계정')),
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => const Diary());
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('업로드', style: TextStyle(fontSize: 40)),
                          )),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => const DiaryList());
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('리스트', style: TextStyle(fontSize: 40)),
                          ))
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _authentication.signOut();
                    Get.offAll(() => const MyHomePage());
                  },
                  child: const Icon(Icons.logout),
                ),
              ),
            );
          }),
    );
  }
}
