class User {
  String picture;
  String username;
  String firstName;
  String lastName;
  String email;
  String phone;
  String city;
  String country;
  String postcode;

  User({
    required this.picture,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.country,
    required this.postcode,
  });

  clone(User other) {
    username = other.username;
    firstName = other.firstName;
    lastName = other.lastName;
    email = other.email;
    phone = other.phone;
    city = other.city;
    country = other.country;
    postcode = other.postcode;
    picture = other.picture;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'country': country,
      'postcode': postcode,
    };
  }

  factory User.cast(Map<String, dynamic> json) {
    return User(
      picture: json['picture']['large'],
      username: json['login']['username'],
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      email: json['email'],
      phone: json['phone'],
      city: json['location']['city'],
      country: json['location']['country'],
      postcode: json['location']['postcode'].toString(),
    );
  }

  void reset() {
    picture = '';
    username = '';
    firstName = '';
    lastName = '';
    email = '';
    phone = '';
    city = '';
    country = '';
    postcode = '';
  }
}
