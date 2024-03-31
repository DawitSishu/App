import 'dart:convert';

import 'package:health_app/Pages/optionsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RegisterData {
  RegisterData({
    this.phoneNumber = '',
    this.password = '',
    this.confirmedPassword = '',
  });
  String phoneNumber;
  String password;
  String confirmedPassword;
  void printRegisterData() {
    print({
      'phoneNumber': phoneNumber,
      'password': password,
      'confirmedPassword': confirmedPassword
    });
  }

  bool checkRegisterData() =>
      phoneNumber.isEmpty || password.isEmpty || confirmedPassword.isEmpty;

  bool passwordCheck() => password == confirmedPassword;

  void convertPhone() {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+251${phoneNumber.substring(1)}';
      return;
    }
    if (phoneNumber.startsWith('2')) {
      phoneNumber = '+$phoneNumber';
      return;
    }
  }

  Future<bool> setValues(String value, userType, userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType.toString());
    await prefs.setString('userId', userId.toString());
    return prefs.setString('token', value);
  }

  register(onCodeSent) async {
    convertPhone();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {},
      verificationFailed: (e) {},
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    await Future.delayed(const Duration(seconds: 10));
  }
}
