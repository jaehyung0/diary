import 'package:diary/diary/diary.dart';
import 'package:diary/diary/diarydetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'menu.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({Key? key}) : super(key: key);

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('리스트'),
          titleSpacing: 0,
          leading: GestureDetector(
              onTap: () {
                Get.offAll(() => const Menu());
              },
              child: const Icon(Icons.arrow_back)),
          actions: [
            GestureDetector(
                onTap: () {
                  Get.to(() => const Diary());
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(Icons.camera_alt_outlined),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('diary')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final diaryInfo = snapshot.data!.docs;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: diaryInfo.length,
                    itemBuilder: (context, index) {
                      Timestamp time = diaryInfo[index].data()['time'];
                      var date = DateTime.fromMillisecondsSinceEpoch(
                          time.seconds * 1000);
                      String title = diaryInfo[index].data()['title'];
                      String content = diaryInfo[index].data()['content'];
                      var image = diaryInfo[index].data()['image'];
                      var id = diaryInfo[index].data()['userId'];
                      final user = FirebaseAuth.instance.currentUser;
                      if (id == user!.uid) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => const DiaryDetail(), arguments: {
                              'title': title,
                              'content': content,
                              'date': date,
                              'image': image
                            });
                          },
                          onLongPress: () {
                            FirebaseFirestore.instance
                                .collection('diary')
                                .doc(diaryInfo[index].id)
                                .delete();
                          },
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  AutoSizeText(title,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.lightBlue),
                                      maxLines: 1),
                                  const SizedBox(height: 15),
                                  Text(
                                      '날짜: ${date.toString().substring(0, 16)}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.deepOrange)),
                                  const SizedBox(height: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.lightBlue),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: AutoSizeText(content,
                                          minFontSize: 25,
                                          maxLines: 8,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    });
              }),
        ));
  }
}
