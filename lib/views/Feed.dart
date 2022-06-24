// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jokestar/models/KeysApp.dart';
import 'package:jokestar/models/User.dart';
import 'package:jokestar/services/ApiService.dart';
import 'package:jokestar/services/SharedPreferenceService.dart';
import 'package:jokestar/views/MainAppView.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String userGlobal = '';
  late double height;
  late double width;
  late TextEditingController searchBarCtrl;
  late TextEditingController contentCtrl;
  final _formKey = GlobalKey<FormState>();
  late Future userInfo;
  bool isInitState = true;
  Posts posts = Posts();

  _setUserGlobal() async {
    userGlobal = await SharedPreferenceService.instance.getString(KeysApp.user);
  }

  @override
  void initState() {
    super.initState();
    searchBarCtrl = TextEditingController();
    contentCtrl = TextEditingController();
    _setUserGlobal();
  }

  @override
  void dispose() {
    searchBarCtrl.dispose();
    contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF343436), actions: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchBarCtrl,
              onChanged: (String text) {
                isInitState = true;
                setState(() {
                  userInfo = ApiService.retrieveUserInfo(searchBarCtrl.text,
                      isSearchBar: true);
                  posts = Posts(username: text);
                });
              },
              decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Find user!",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF343436)))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.black54,
              ),
              onPressed: () {
                SharedPreferenceService.instance.removeValue(KeysApp.user);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MainAppView()));
              },
              child: const Text("Logout")),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    
                  });
                },
                child: Image.asset('assets/refresh.png')))
      ]),
      body: _body(),
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
        future: userInfo,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data != null && snapshot.data.runtimeType != String) {
            User user = User(
                snapshot.data['username'],
                snapshot.data['name'],
                snapshot.data['firstSurname'],
                snapshot.data['secondSurname'],
                isBeingFollowed: snapshot.data['isBeingFollowed'] ?? '');
            return SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${user.name} ${user.firstSurname} ${user.secondSurname}"),
                  ),
                  userGlobal != user.username
                      ? user.isBeingFollowed!.isEmpty &&
                              user.isBeingFollowed != null
                          ? TextButton(
                              onPressed: () async {
                                await ApiService.followUser(
                                    following: user.username);
                                var update = ApiService.retrieveUserInfo(
                                    user.username, isSearchBar: true);
                                setState(() {
                                  userInfo = update;
                                });
                              },
                              child: const Text("Follow"))
                          : TextButton(
                              onPressed: () async {
                                await ApiService.unfollowUser(
                                    following: user.username);
                                var update = ApiService.retrieveUserInfo(
                                    user.username, isSearchBar: true);
                                setState(() {
                                  userInfo = update;
                                });
                              },
                              child: const Text("Unfollow"))
                      : const SizedBox.shrink()
                ],
              ),
            );
          } else {
            return Text(snapshot.data);
          }
        });
  }

  Widget _streamBuilder() {
    return StreamBuilder(
        stream: posts.postListView,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState != ConnectionState.done && isInitState) {
            isInitState = false;
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data != null && snapshot.data.length > 0
              ? _search(snapshot.data)
              : const SizedBox.shrink();
        });
  }

  Widget _search(dynamic data) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return feed(data, index);
            }),
      ),
    );
  }

  Widget feed(List<dynamic> data, int index) {
    String uuid = data[index]['uuid'];
    String username = data[index]['username'];
    String content = data[index]['content'];

    List<Widget> getButton() {
      if (userGlobal == username) {
        return <Widget>[
          TextButton(
              onPressed: () async {
                await ApiService.deleteUserPost(uuid: uuid);
                setState(() {});
              },
              child: const Text("Delete"))
        ];
      }
      return <Widget>[];
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Column(
        children: <Widget>[
          Row(
              children: <Widget>[Text('${uuid.split('.')[0]} $username')] +
                  getButton()),
          Flexible(flex: 0, child: Text(content))
        ],
      ),
    );
  }

  Widget _body() {
    return Center(
        child: SingleChildScrollView(
      child: SizedBox(
        height: height,
        child: searchBarCtrl.text.isEmpty
            ? Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.1,
                                right: width * 0.1,
                                top: height / 90),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: contentCtrl,
                              decoration: const InputDecoration(
                                  hintText: "What's up in your mind...?",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF343436)))),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.1, right: width * 0.5),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await ApiService.postSomething(
                                        content: contentCtrl.text);
                                    setState(() {});
                                  }
                                  contentCtrl.clear();
                                },
                                child: const Text("Publish")))
                      ],
                    ),
                  ),
                  _streamBuilder(),
                ],
              )
            : Column(
                children: [
                  _futureBuilder(),
                  _streamBuilder(),
                ],
              ),
      ),
    ));
  }
}

class Posts {
  String? username;

  final StreamController _posts = StreamController();
  Stream get posts => _posts.stream;

  Stream get postListView async* {
    yield await ApiService.retrieveUserPosts(userSearch: username ?? "");
  }

  Posts({this.username}) {
    postListView.listen((event) {
      _posts.add(postListView.length);
    });
  }
}
