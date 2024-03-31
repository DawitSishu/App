import 'dart:convert';
import 'package:health_app/Services/general-controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrganizationData {
  OrganizationData({
    this.organizationName = '',
    this.organizationType = '',
    this.emailAddress = '',
    this.phoneNumber = '',
    this.city = '',
    this.subCity = '',
    this.wereda = '',
    this.houseNumber = '',
    this.tinNumber = '',
    this.contactPersonName = '',
    this.contactPersonPosition = '',
    this.contactPersonPhoneNumber = '',
  });
  String organizationName;
  String organizationType;
  String emailAddress;
  String phoneNumber;
  String city;
  String subCity;
  String wereda;
  String houseNumber;
  String tinNumber;
  String contactPersonName;
  String contactPersonPosition;
  String contactPersonPhoneNumber;

  void printOrganizationData() {
    print({
      'organizationName': organizationName,
      'organizationType': organizationType,
      'emailAdress': emailAddress,
      'phoneNumber': phoneNumber,
      'city': city,
      'subCity': subCity,
      'wereda': wereda,
      'houseNumber': houseNumber,
      'tinNumber': tinNumber,
      'contactPersonName': contactPersonName,
      'contactPersonPosition': contactPersonPosition,
      'contactPersonPhoneNumber': contactPersonPhoneNumber,
    });
  }

  bool checkOrganizationData() {
    return (organizationName.isEmpty ||
        organizationType.isEmpty ||
        emailAddress.isEmpty ||
        phoneNumber.isEmpty ||
        city.isEmpty ||
        subCity.isEmpty ||
        wereda.isEmpty ||
        houseNumber.isEmpty ||
        tinNumber.isEmpty ||
        contactPersonName.isEmpty ||
        contactPersonPosition.isEmpty ||
        contactPersonPhoneNumber.isEmpty);
  }

  sendData() async {
    //id
    final url =
        Uri.http('196.188.127.211:10000', '/organization/organization-info');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Await the http get response, then decode the json-formatted response.

    final creationStatus = await updateProfileStatus("pending");
    if (creationStatus.statusCode == 200) {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'name': organizationName,
          'type': organizationType,
          'email': emailAddress,
          'phoneNumber': phoneNumber,
          'city': city,
          'subCity': subCity,
          'wereda': wereda,
          'houseNo': houseNumber,
          'tinNo': tinNumber,
          'contactPersonName': contactPersonName,
          'contactPersonPosition': contactPersonPosition,
          'contactPersonNumber': contactPersonPhoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData;
      } else {
        return null;
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
