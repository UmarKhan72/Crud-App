import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  late String imagePath;

  final Stream<QuerySnapshot> postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

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

    void submit() async {
      try {
        String title = titleController.text;
        String description = descriptionController.text;

        String imageName = path.basename(imagePath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloaddeURL = await ref.getDownloadURL();
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").add(
            {"title": title, "description": description, "url": downloaddeURL});

        print("post uploaded successfully");
        titleController.clear();
        descriptionController.clear();
        // Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    void logout() async {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.signOut();
        await Navigator.of(context).pushNamed("/gopage");
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
            child: Column(
          children: [
            ElevatedButton(onPressed: logout, child: Text("Logout")),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Enter title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Enter description'),
            ),
            ElevatedButton(onPressed: pickImage, child: Text("Pick an Image")),
            ElevatedButton(onPressed: submit, child: Text("Submit a post")),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: postStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map data = document.data();
                        String id = document.id;
                        data["id"] = id;

                        return Post(data);
                      }).toList(),
                    );
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );

    // void alertuk() async {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           content: Container(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 ElevatedButton(onPressed: logout, child: Text("Logout")),
    //                 TextFormField(
    //                   controller: titleController,
    //                   decoration: InputDecoration(labelText: 'Enter title'),
    //                 ),
    //                 TextFormField(
    //                   controller: descriptionController,
    //                   decoration:
    //                       InputDecoration(labelText: 'Enter description'),
    //                 ),
    //                 ElevatedButton(
    //                     onPressed: pickImage, child: Text("Pick an Image")),
    //                 ElevatedButton(
    //                     onPressed: submit, child: Text("Submit a post")),
    //               ],
    //             ),
    //           ),
    //         );
    //       });
    // }

    // return Scaffold(
    //   body: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     child: SafeArea(
    //         child: Column(
    //       children: [
    //         ElevatedButton(onPressed: alertuk, child: Text("Create Post")),
    //         Expanded(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: 20),
    //             child: StreamBuilder<QuerySnapshot>(
    //               stream: postStream,
    //               builder: (BuildContext context,
    //                   AsyncSnapshot<QuerySnapshot> snapshot) {
    //                 if (snapshot.hasError) {
    //                   return Text('Something went wrong');
    //                 }

    //                 if (snapshot.connectionState == ConnectionState.waiting) {
    //                   return Text("Loading");
    //                 }

    //                 return ListView(
    //                   children:
    //                       snapshot.data!.docs.map((DocumentSnapshot document) {
    //                     Map data = document.data();
    //                     String id = document.id;
    //                     data["id"] = id;

    //                     return Post(data);
    //                   }).toList(),
    //                 );
    //               },
    //             ),
    //           ),
    //         )
    //       ],
    //     )),
    //   ),
    // );
  }
}
