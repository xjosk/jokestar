// ignore: file_names
import 'package:flutter/material.dart';
import 'package:jokestar/models/KeysApp.dart';
import 'package:jokestar/services/SharedPreferenceService.dart';
import 'package:jokestar/views/Feed.dart';
import 'package:jokestar/views/LogIn.dart';
import 'package:jokestar/views/SignUp.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'dart:convert';

class MainAppView extends StatefulWidget {
  const MainAppView({Key? key}) : super(key: key);

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  // String image = '';

  // void getImage() async {
  //   String base64string = base64Encode((await rootBundle.load('assets/star.png')).buffer.asUint8List());
  //   setState(() {
  //     image = base64string;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    validatesSession();
  }

  void validatesSession() async {
    String user =
        await SharedPreferenceService.instance.getString(KeysApp.user);
    if (user.isNotEmpty) {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Feed()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF424242), Colors.black87],
            ),
          ),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/star.png',
                      height: height * 0.4, width: width * 0.4),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: OutlinedButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.white,
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                                vertical: height * 0.01),
                            backgroundColor: Colors.transparent),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogIn()));
                        },
                        child: const Text("Login")),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            primary: Colors.black87,
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                                vertical: height * 0.01),
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text("Sign Up")),
                  )
                ]),
          )),
        ));
  }
}
