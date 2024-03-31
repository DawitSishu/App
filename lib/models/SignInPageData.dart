import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Pages/optionsPage.dart';

class SignInData {
  SignInData({this.phoneNumber = '', this.password = ''});
  String phoneNumber;
  String password;
  void printSignInData() {
    print({'phoneNumber': phoneNumber, 'password': password});
  }

  bool checksignIn() => phoneNumber.isEmpty || password.isEmpty;

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

  Future<dynamic> signIn() async {
    try {
      convertPhone();
      final email = '$phoneNumber@healthapp.com';
      final url = Uri.http('196.188.127.211:10000', '/login');

      final response =
          await http.post(url, body: {'email': email, 'password': password});
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseBody['token'].toString();
        final status = responseBody['profileCreationStatus'];
        final userType = responseBody['userType'];
        final paymentStatus = responseBody['paymentStatus'];
        var route = '';

        // print('token: $responseBody $token ${response.statusCode}');
        await setValues(token, userType, responseBody['user_id'], phoneNumber);

        final prefs = await SharedPreferences.getInstance();
        print(responseBody);
        await prefs.setInt('id', responseBody['roleID'] ?? 0);

        // if (responseBody['roleID'] != null) {
        //   await prefs.setInt('id', responseBody['roleID']);
        // }
        if (status == "afterExp") {
          if (userType == "professional") {
            route = 'documents-page';
          }
        } else if (status == 'pending') {
          if (userType == 'organization') {
            route = 'organization-page-info2';
          } else {
            route = 'experience-page';
          }
        } else if (status == 'uncompleted') {
          if (userType == 'organization') {
            route = 'organization-page-info';
          } else {
            route = 'personal-info-page';
          }
        } else {
          if (paymentStatus == 'paid') {
            // if (true) {
            if (userType == 'organization') {
              route = 'health-institution-page';
            } else {
              route = 'health-professional-page';
            }
          } else if (paymentStatus == 'pending') {
            route = 'pending-payment-page';
          } else {
            if (userType == 'organization') {
              route = 'payment-page';
            } else {
              route = 'payment-page';
            }
          }
        }
        return {
          'success': true,
          'error': {},
          'route': route,
        };
      } else {
        return {'success': false, 'error': responseBody['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e};
    }
  }

  Future<bool> setValues(String value, userType, userId, ph) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType.toString());
    await prefs.setString('userId', userId.toString());
    await prefs.setString('phoneNumber', ph.toString());
    return prefs.setString('token', value);
  }

  Future<dynamic> register() async {
    try {
      convertPhone();
      User? user = FirebaseAuth.instance.currentUser;
      String uuid = user!.uid;
      final email = '$phoneNumber@healthapp.com';
      final url = Uri.http('196.188.127.211:10000', '/register');
      final userType = OptionsPage.employee ? 'professional' : 'organization';
      final body = {
        'uuid': uuid,
        'email': email,
        'password': password,
        'user_type': userType,
        'phoneNumber': phoneNumber,
        'paymentStatus': 'unpaid',
        'profileCreationStatus': 'uncompleted',
        'longitude': '24.93545',
        'latitude': '60.16952'
      };
      final response = await http.post(url, body: body);
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseBody['token'].toString();
        print('token: $responseBody $token ${response.statusCode}');
        await setValues(token, responseBody['userType'],
            responseBody['user_id'], phoneNumber);
        return {'success': true, 'error': {}};
      } else {
        return {'success': false, 'error': responseBody['message']};
      }
    } catch (e) {
      return {'success': false, 'error': e};
    }
  }
}
