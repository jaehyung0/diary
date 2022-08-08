import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diary.dart';
import 'diarylist.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/beach.jpg'))),
      child: Scaffold(
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
          },
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
