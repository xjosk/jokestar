import 'package:flutter/material.dart';
import 'package:jokestar/views/MainAppView.dart';
import 'models/Routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: const MainAppView(),
      routes: _asignRoutes(const MainAppView()),
    );
  }

  Map<String, WidgetBuilder> _asignRoutes(Widget route) {
    return {
      Routes.mainAppView: (context) => route,
    };
  }
}
