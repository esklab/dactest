
class UserController {
  bool isInputValid(
      String pseudo,
      String firstName,
      String lastName,
      String email,
      String phone,
      String city,
      String country,
      String postcode,
      String picture) {
    if (pseudo.isNotEmpty &&
        email.isNotEmpty &&
        isEmailValid(email) &&
        phone.isNotEmpty &&
        isPhoneValid(phone) &&
        city.isNotEmpty &&
        country.isNotEmpty &&
        postcode.isNotEmpty &&
        isImageURLValid(picture)) {
      return true;
    }
    return false;
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  bool isPhoneValid(String phone) {
    final phoneRegExp = RegExp(r'^\+?\d+$');
    return phoneRegExp.hasMatch(phone);
  }

  bool isImageURLValid(String imageURL) {
    final urlRegExp = RegExp(r'^https?://\S+$');
    return urlRegExp.hasMatch(imageURL);
  }
}
