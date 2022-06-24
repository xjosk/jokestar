class User {
  String username = "";
  String? password = "";
  String? isBeingFollowed = "";
  String name = "";
  String firstSurname = "";
  String secondSurname = "";

  User(this.username, this.name, this.firstSurname, this.secondSurname,
      {this.password, this.isBeingFollowed});

  Map<String, String> toJson() => {
        'username': username,
        'password': password ?? '',
        'name': name,
        'firstSurname': firstSurname,
        'secondSurname': secondSurname,
        'isBeingFollowed': isBeingFollowed ?? ''
      };
}
