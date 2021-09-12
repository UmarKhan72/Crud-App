import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController();
    final TextEditingController passwordController =
        TextEditingController();

    void login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        final DocumentSnapshot snapshot =
            await db.collection("users").doc(user.user.uid).get();

        final data = snapshot.data();


        Navigator.of(context).pushNamed("/home" , arguments: data,);
        // emailController.clear();
        // passwordController.clear();
      } 
      on FirebaseAuthException catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(e.message),
              );
            });
      }
      catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Enter your email'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Enter your password'),
                ),
                ElevatedButton(onPressed: login, child: Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
