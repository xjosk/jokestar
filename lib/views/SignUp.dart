// ignore: file_names
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jokestar/models/User.dart';
import 'package:jokestar/services/ApiService.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final userCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final firstSurnameCtrl = TextEditingController();
  final secondSurnameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userCtrl.dispose();
    passwordCtrl.dispose();
    nameCtrl.dispose();
    firstSurnameCtrl.dispose();
    secondSurnameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Sign Up")), body: _body());
  }

  Widget _body() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
        child: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                decoration: const InputDecoration(hintText: "Username"))),
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
                decoration: const InputDecoration(hintText: "Password"))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: "Name"))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: firstSurnameCtrl,
                decoration: const InputDecoration(hintText: "First Surname"))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: secondSurnameCtrl,
                decoration: const InputDecoration(hintText: "Second Surname"))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var key = utf8.encode(passwordCtrl.text);
                    var digest = md5.convert(key);

                    ApiService.signUp(
                        user: User(
                            userCtrl.text.toLowerCase(),
                            nameCtrl.text,
                            firstSurnameCtrl.text,
                            secondSurnameCtrl.text,
                            password: 
                            digest.toString()));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Sign Up!")))
      ]),
    )));
  }
}



// import 'dart:convert';

// import 'package:crypto/crypto.dart';

// void main(){
//   var key = utf8.encode('p@ssw0rd');
//   var bytes = utf8.encode("foobar");

//   var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
//   var digest = hmacSha256.convert(bytes);

//   print("HMAC digest as bytes: ${digest.bytes}");
//   print("HMAC digest as hex string: $digest");
// }