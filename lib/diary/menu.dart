import 'package:diary/date_calendar/date_calendar.dart';
import 'package:diary/main.dart';
import 'package:diary/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diary.dart';
import 'diarylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

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
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, bottom: 100, right: 20, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const Diary());
                                },
                                borderRadius: BorderRadius.circular(15),
                                highlightColor: Colors.yellowAccent,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.cyan)),
                                  child: FittedBox(
                                    child: Column(
                                      children: const [
                                        Icon(
                                          Icons.file_upload_rounded,
                                        ),
                                        Text('업로드')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => const DiaryList());
                                },
                                borderRadius: BorderRadius.circular(15),
                                highlightColor: Colors.yellowAccent,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.cyan)),
                                  child: FittedBox(
                                    child: Column(
                                      children: const [
                                        Icon(Icons.list_alt),
                                        Text('리스트')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => const DateCalendar());
                              },
                              borderRadius: BorderRadius.circular(15),
                              highlightColor: Colors.yellowAccent,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.cyan)),
                                child: FittedBox(
                                  child: Column(
                                    children: const [
                                      Icon(Icons.calendar_month_sharp),
                                      Text('달력')
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
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
