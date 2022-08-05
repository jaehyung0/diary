import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiaryDetail extends StatefulWidget {
  const DiaryDetail({Key? key}) : super(key: key);

  @override
  State<DiaryDetail> createState() => _DiaryDetailState();
}

class _DiaryDetailState extends State<DiaryDetail> {
  Map<String, dynamic> map = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세보기')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      map['title'],
                      style: const TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(map['image'], fit: BoxFit.fitWidth),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width - 40,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(map['content'],
                        style: const TextStyle(fontSize: 20)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
