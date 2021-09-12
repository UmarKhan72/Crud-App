import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditDialog extends StatefulWidget {
  final Map data;

  EditDialog({required this.data});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late String imagePath;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.data["title"];
    descriptionController.text = widget.data["description"];
  }

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);
      print(image.path);

      setState(() {
        imagePath = image.path;
      });
    }

    void done() async {
      try {
        String imageName = path.basename(imagePath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloaddeURL = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;

        Map<String, dynamic> newPost = {
          "title": titleController.text,
          "description": descriptionController.text,
          "url": downloaddeURL
        };

        await db.collection("posts").doc(widget.data["id"]).set(newPost);
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Enter title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Enter description'),
            ),
            ElevatedButton(onPressed: pickImage, child: Text("Pick an Image")),
            ElevatedButton(onPressed: done, child: Text("Done")),
          ],
        ),
      ),
    );
  }
}
