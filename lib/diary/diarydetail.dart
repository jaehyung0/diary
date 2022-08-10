import 'package:auto_size_text/auto_size_text.dart';
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 15),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width - 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        map['title'],
                        style: const TextStyle(
                            fontSize: 30, color: Colors.lightBlue),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red)),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('사진'),
                                content: SingleChildScrollView(
                                  child: FittedBox(
                                    child: Image.network(
                                      map['image'],
                                      loadingBuilder: (BuildContext context,
                                          Widget child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          map['image'],
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
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
      ),
    );
  }
}
