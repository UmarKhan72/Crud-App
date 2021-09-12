import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class GoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200,),
            Container(
              child: Image.network(
                  "https://miro.medium.com/max/768/1*gjA78w2_Q8lSNZAnTMScqA.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110,top: 30),
              child: Row(
                children: [
                  Container(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text("Login"))),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            },
                            child: Text("Register"))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
