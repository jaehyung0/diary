import 'package:diary/diary/diary.dart';
import 'package:diary/diary/diarydetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          leading: const SizedBox(),
          titleSpacing: 0,
          actions: [
            GestureDetector(
                onTap: () {
                  Get.to(() => const Diary());
                },
                child: const Icon(Icons.camera_alt))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('diary')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
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
                            return InkWell(
                              onTap: () {
                                Get.to(() => const DiaryDetail(), arguments: {
                                  'title': title,
                                  'content': content,
                                  'date': date,
                                  'image': image
                                });
                              },
                              child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(title,
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.lightBlue)),
                                            Text(
                                              date.toString().substring(0, 19),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(content,
                                          style: const TextStyle(fontSize: 25))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    })),
          ),
        ));
  }
}
