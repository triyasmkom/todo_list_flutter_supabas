class Validator {
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? email(String? value) {
    // add email validation
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);

    if (!emailValid) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return "Please enter some text";
    }

    if (value != original) {
      return "Password does not match";
    }

    return null;
  }
}
