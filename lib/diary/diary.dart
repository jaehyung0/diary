import 'dart:io';
import 'package:diary/diary/diarylist.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Diary extends StatelessWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DiaryPage();
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  File? userPickedImage;

  void pickedImageFunc(File image) {
    userPickedImage = image;
  }

  File? pickedImage;
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: MediaQuery.of(context).size.width - 40,
    );

    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });

    pickedImageFunc(pickedImage!);
  }

  void _albumImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: MediaQuery.of(context).size.width - 40,
    );

    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });

    pickedImageFunc(pickedImage!);
  }

  String title = '';
  String content = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('다이어리')),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: '제목',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                // borderSide: BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                            onSaved: (value) {
                              title = value.toString();
                            },
                            onChanged: (value) {
                              title = value.toString();
                            })),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _albumImage();
                              },
                              child: const Text('앨범')),
                          ElevatedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            child: pickedImage != null
                                ? Image(
                                    image: FileImage(pickedImage!),
                                  )
                                : const Text('사진'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 10,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '내용(10줄까지만)'),
                        onSaved: (value) {
                          content = value.toString();
                        },
                        onChanged: (value) {
                          content = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            final path = 'files/${userPickedImage!.path}';

                            final refImage =
                                FirebaseStorage.instance.ref().child(path);
                            await refImage.putFile(userPickedImage!);

                            final url = await refImage.getDownloadURL();

                            FirebaseFirestore.instance.collection('diary').add({
                              'title': title,
                              'content': content,
                              'time': Timestamp.now(),
                              'image': url
                            });

                            Get.snackbar('완료', '업로드완료');
                            Get.to(() => const DiaryList());
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('에러나옴'),
                                backgroundColor: Colors.blue,
                              ));
                            }
                          }
                        },
                        child: const Text('등록'))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
