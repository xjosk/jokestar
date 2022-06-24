enum ApiRoutes { USERS, POSTS, FOLLOWERS }

class Properties {
  static String apiKey = 'gk99MrdDcG9ra9ZlzZ0Vh20myhjFbET55GDyL4Ye';
  static String apiBaseUrl =
      'https://fqtdqrmql9.execute-api.us-east-1.amazonaws.com/apiandrei';

  Properties._privateConstructor();
  static final Properties instance = Properties._privateConstructor();

  String getRoute(ApiRoutes route) {
    switch (route) {
      case ApiRoutes.USERS:
        return apiBaseUrl + '/usermanagement/';
      case ApiRoutes.POSTS:
        return apiBaseUrl + '/postmanagement/';
      case ApiRoutes.FOLLOWERS:
        return apiBaseUrl + '/followermanagement/';
      default:
        return apiBaseUrl;
    }
  }
}
