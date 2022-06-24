import 'dart:convert';

import 'package:jokestar/models/ApiHeader.dart';
import 'package:jokestar/models/ApiRoutes.dart';
import 'package:http/http.dart' as http;
import 'package:jokestar/models/KeysApp.dart';
import 'package:jokestar/models/User.dart';
import 'package:jokestar/services/SharedPreferenceService.dart';

class ApiService {
  static Map<String, String> getHeader() {
    return ApiHeader('application/json', Properties.apiKey).toJson();
  }

  static Future<dynamic> retrieveUserInfo(String username,
      {bool isSearchBar = false}) async {
    String url = Properties.instance.getRoute(ApiRoutes.USERS);
    String currentUser = isSearchBar
        ? "/" + await SharedPreferenceService.instance.getString(KeysApp.user)
        : '';

    var header = getHeader();
    final response = await http.get(
        Uri.parse(url + username + "$currentUser?isSearchBar=$isSearchBar"),
        headers: header);

    if (response.statusCode != 200) {
      if (response.statusCode == 502) {
        return "This user doesn't appear in our database!";
      }
      throw ('Ocurrió un error inesperado al validar la información');
    }

    String body = utf8.decode(response.bodyBytes);

    final jsonData = jsonDecode(body);

    return jsonData;
  }

  static signUp({required User user}) async {
    String url = Properties.instance.getRoute(ApiRoutes.USERS);
    var header = getHeader();
    var body = jsonEncode(user.toJson());
    final response =
        await http.post(Uri.parse(url), headers: header, body: body);

    if (response.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }
  }

  static postSomething({required String content}) async {
    String url = Properties.instance.getRoute(ApiRoutes.POSTS);
    String username =
        await SharedPreferenceService.instance.getString(KeysApp.user);
    var header = getHeader();
    var body = jsonEncode({"content": content});
    final response =
        await http.post(Uri.parse(url + username), headers: header, body: body);

    if (response.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }
  }

  static Future<dynamic> retrieveUserPosts({String userSearch = ''}) async {
    String url = Properties.instance.getRoute(ApiRoutes.POSTS);
    String username = userSearch.trim().isEmpty
        ? await SharedPreferenceService.instance.getString(KeysApp.user)
        : userSearch;

    bool isSearchBar = userSearch.trim().isEmpty ? false : true;

    var header = getHeader();
    final request = await http.get(
        Uri.parse(url + username + "?isSearchBar=$isSearchBar"),
        headers: header);

    if (request.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }

    var response = jsonDecode(request.body);

    return response['Items'];
  }

  static deleteUserPost({required String uuid}) async {
    String url = Properties.instance.getRoute(ApiRoutes.POSTS);
    String username =
        await SharedPreferenceService.instance.getString(KeysApp.user);
    var header = getHeader();
    var body = jsonEncode({"uuid": uuid});
    final request = await http.delete(Uri.parse(url + username),
        headers: header, body: body);

    if (request.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }
  }

  static followUser({required String following}) async {
    String url = Properties.instance.getRoute(ApiRoutes.FOLLOWERS);
    String username =
        await SharedPreferenceService.instance.getString(KeysApp.user);
    var header = getHeader();
    var body = jsonEncode({'following': following});
    final request =
        await http.post(Uri.parse(url + username), headers: header, body: body);

    if (request.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }
  }

  static unfollowUser({required String following}) async {
    String url = Properties.instance.getRoute(ApiRoutes.FOLLOWERS);

    String username =
        await SharedPreferenceService.instance.getString(KeysApp.user);

    var header = getHeader();
    var body = jsonEncode({'following': following});

    final request = await http.delete(Uri.parse(url + username),
        headers: header, body: body);

    
    print(jsonEncode(request.body));
    if (request.statusCode != 200) {
      throw ('Ocurrió un error inesperado al validar la información');
    }

  }
}
