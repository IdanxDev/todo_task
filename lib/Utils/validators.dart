class Validators {
  // --------------- non empty validator ---------------
  NonEmptyValidate(String text) {
    if (text.length == 0) {
      return "add something";
    } else {
      return true;
    }
  }

  // --------------- non empty validator ---------------
  passwordValidate(String password) {
    if (password.length == 0) {
      return "add password";
    } else if (password.length < 7) {
      return "Minimum 7 Character is Required";
    } else {
      return true;
    }
  }

  // --------------- email validator ---------------
  EmailValidate(String email) {
    if (email.length == 0) {
      return "add email address";
    } else if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return "add valid email address";
    }
  }

  // --------------- phone validator ---------------
  PhoneValidate(String mobileNumber) {
    if (mobileNumber.length == 0) {
      return "add mobile Number";
    } else if (RegExp(r"^[0-9]").hasMatch(mobileNumber)) {
      return true;
    } else {
      return "add valid mobile Number";
    }
  }
}
