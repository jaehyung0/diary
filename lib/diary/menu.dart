import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'diary.dart';
import 'diarylist.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Get.to(() => const Diary());
              },
              child: const Text('업로드')),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const DiaryList());
              },
              child: const Text('리스트'))
        ],
      ),
    ));
  }
}
