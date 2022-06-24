import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jokestar/models/KeysApp.dart';
import 'package:jokestar/models/Routes.dart';
import 'package:jokestar/services/ApiService.dart';
import 'package:jokestar/services/SharedPreferenceService.dart';
import 'package:jokestar/views/Feed.dart';
import 'package:jokestar/views/ForgottenPassword.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final userCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void login() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: const Color(0xFF343436)),
        body: _body());
  }

  Widget _body() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(
          child: Text("Login",
              style: TextStyle(
                  color: const Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.1)),
        ),
        SizedBox(height: height / 15),
        Padding(
          padding: EdgeInsets.only(left: width * 0.15, bottom: height * 0.01),
          child: const Text("Username",
              style: TextStyle(color: Color(0xFF343436))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: userCtrl,
            decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/user1.png'),
                ),
                prefixIconConstraints:
                    BoxConstraints.tight(Size(width / 12, height / 12)),
                hintText: "Type your username/email",
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Color(0xFF343436)))),
          ),
        ),
        SizedBox(height: height / 30),
        Padding(
          padding: EdgeInsets.only(left: width * 0.15, bottom: height * 0.01),
          child: const Text("Password",
              style: TextStyle(color: Color(0xFF343436))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: passwordCtrl,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/pswd.png'),
                ),
                prefixIconConstraints:
                    BoxConstraints.tight(Size(width / 12, height / 12)),
                hintText: "Password",
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Color(0xFF343436)))),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: width * 0.50, bottom: width / 10),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgottenPassword()));
              },
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              child: const Text("Forgot password?",
                  style: TextStyle(color: Color(0xFF909090))),
            )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height / 40),
                  backgroundColor: const Color(0xFF343436)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var userInfo = await ApiService.retrieveUserInfo(
                      userCtrl.text.toLowerCase());
                  var key = utf8.encode(passwordCtrl.text);
                  var digest = md5.convert(key);

                  if (userInfo['password'] == digest.toString()) {
                    SharedPreferenceService.instance
                        .setString(KeysApp.user, userCtrl.text);
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(Routes.mainAppView));
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Feed()));
                  }
                }
              },
              child: const Text("LOGIN"),
            ))
      ]),
    )));
  }
}
