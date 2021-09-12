import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/editDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final Map data;
  Post(this.data);

  @override
  Widget build(BuildContext context) {
    void deletePost() async {
      try {
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").doc(data["id"]).delete();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    void editPost() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditDialog(data: data);
          });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              data["url"],
              width: 350,
              height: 250,
            ),
            Text(
              data["title"],
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              data["description"],
              style: TextStyle(fontSize: 17.5),
            ),
            ElevatedButton(onPressed: deletePost, child: Text("Delete")),
            ElevatedButton(onPressed: editPost, child: Text("Edit"))
          ],
        ),
      ),
    );
  }
}
