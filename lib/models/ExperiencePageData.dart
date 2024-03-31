import 'dart:convert';

import 'package:health_app/Services/general-controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExperienceData {
  ExperienceData({
    this.educationLevel = '',
    this.workExperienceYears = '',
    this.employerName = '',
    this.positionHeld = '',
    this.startingDateWithCompany,
    this.endingDateWithCompany,
    this.mainResponsibilities = '',
  });
  String educationLevel;
  String workExperienceYears;
  String employerName;
  String positionHeld;
  DateTime? startingDateWithCompany;
  DateTime? endingDateWithCompany;
  String mainResponsibilities;

  void PrintExperienceData() {
    print({
      'educationLevel': educationLevel,
      'workExperienceYears': workExperienceYears,
      'employerName': employerName,
      'positionHeld': positionHeld,
      'startingDateWithCompany': startingDateWithCompany,
      'endingDateWithCompany': endingDateWithCompany,
      'mainResponsibilities': mainResponsibilities
    });
  }

  bool checkExperienceData() {
    return (educationLevel.isEmpty ||
        workExperienceYears.isEmpty ||
        employerName.isEmpty ||
        positionHeld.isEmpty ||
        startingDateWithCompany == null ||
        endingDateWithCompany == null ||
        mainResponsibilities.isEmpty);
  }

  sendData() async {
    final id = await getIdOfUser();
    final url = Uri.http(
        '196.188.127.211:10000', '/professional/edu-work-experience/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // Await the http get response, then decode the json-formatted response.

    final creationStatus = await updateProfileStatus("afterExp");
    if (creationStatus.statusCode == 200) {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'educationLevel': educationLevel,
          'workExperienceYear': workExperienceYears,
          'employerName': employerName,
          'positionHeld': positionHeld,
          'startingDate': startingDateWithCompany!.toIso8601String(),
          'endingDate': endingDateWithCompany!.toIso8601String(),
          'mainResponsibilities': mainResponsibilities,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
