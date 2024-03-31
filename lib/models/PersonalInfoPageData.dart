import 'dart:convert';

import 'package:health_app/Services/general-controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PersonalData {
  PersonalData({
    this.firstName = '',
    this.lastName = '',
    this.age = '',
    this.gender = '',
    this.city = '',
    this.subCity = '',
    this.wereda = '',
    this.email = '',
    this.phoneNumber = '',
    this.profession = '',
    this.languages = const [],
    this.skills = '',
  });
  String firstName;
  String lastName;
  String age;
  String gender;
  String city;
  String subCity;
  String wereda;
  String email;
  String phoneNumber;
  String profession;
  List languages;
  String skills;

  void printPersonalData() {
    print({
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender,
      'city': city,
      'subCity': subCity,
      'wereda': wereda,
      'email': email,
      'phoneNumber': phoneNumber,
      'profession': profession,
      'languages': languages
    });
  }

  bool checkPersonalData() =>
      firstName.isEmpty ||
      lastName.isEmpty ||
      age.isEmpty ||
      gender.isEmpty ||
      city.isEmpty ||
      subCity.isEmpty ||
      wereda.isEmpty ||
      email.isEmpty ||
      profession.isEmpty ||
      languages.isEmpty ||
      skills.isEmpty;

  sendData() async {
    try {
      final url =
          Uri.http('196.188.127.211:10000', '/professional/personal-info');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final phoneNumber = prefs.getString('phoneNumber');
      final userId = prefs.getString('userId');

      // Await the http get res...data, "Age": data['Age'] as intponse, then decode the json-formatted response.

      final creationStatus = await updateProfileStatus("pending");
      if (creationStatus.statusCode == 200) {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'user_id': int.parse(userId!),
            'firstName': firstName,
            'lastName': lastName,
            'Age': int.parse(age),
            'Gender': gender,
            'city': city,
            'subCity': subCity,
            'wereda': wereda,
            'email': email,
            'phoneNumber': phoneNumber,
            'profession': profession,
            'languages': languages.join(', '),
            'Skills': skills,
          }),
        );

        print(json.decode(response.body));
        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          return decodedData;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      // TODO
      print(e);
      return null;
    }
  }
}
