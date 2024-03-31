import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostedJobData {
  String jobPosition;
  String salary;
  DateTime? deadline;
  String jobType;
  String numberOfEmployees;
  String prerequisites;
  String description;
  String rolesAndResponsibilities;
  String experienceLevel;
  String catagory;
  String workLocation;

  PostedJobData({
    this.jobPosition = "",
    this.salary = "",
    this.deadline,
    this.jobType = "",
    this.numberOfEmployees = "",
    this.prerequisites = "",
    this.description = "",
    this.rolesAndResponsibilities = "",
    this.experienceLevel = "",
    this.catagory = "",
    this.workLocation = "",
  });

  bool checkJobData() =>
      jobPosition == "" ||
      salary == "" ||
      deadline == null ||
      jobType == "" ||
      numberOfEmployees == "" ||
      prerequisites == "" ||
      description == "" ||
      rolesAndResponsibilities == "" ||
      catagory == "" ||
      workLocation == "";

  pintPostedJobData() {
    print({
      "jobPosition": jobPosition,
      "salary": salary,
      "deadline": deadline,
      "jobType": jobType,
      "numberOfEmployees": int.parse(numberOfEmployees),
      "prerequisites": prerequisites,
      "description": description,
      "rolesAndResponsibilities": rolesAndResponsibilities,
      "catagory": catagory,
    });
    return {
      "JobPosition": jobPosition,
      "Salary": salary,
      "Deadline": deadline,
      "JobType": jobType,
      "NumberOfEmployees": int.parse(numberOfEmployees),
      "Prerequisites": prerequisites,
      "Descriptions": description,
      "RolesAndResponsibilities": rolesAndResponsibilities,
      "Catagory": catagory,
      "WorkLocation": workLocation,
    };
  }

  sendData() async {
    try {
      final url = Uri.http('196.188.127.211:10000', '/organization/my-jobs');
      final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidHlwZSI6Im9yZ2FuaXphdGlvbiIsInBheW1lbnRTdGF0dXMiOiJwYWlkIiwiaWF0IjoxNjk3NTI4MTQzfQ.CXbr1bNgOFGc0kwygIa9y6GdKfDiB5_O39_-PrH5mCk";
      // final userId = prefs.getString('userId');
      final id = prefs.getInt('id');
      // Await the http get response, then decode the json-formatted response.

      //skills
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'organizationId': "$id",
          'jobPosition': jobPosition,
          'salary': salary,
          'deadline': deadline?.toIso8601String(),
          'jobType': jobType,
          'numberOfEmployees': numberOfEmployees,
          'prerequisites': prerequisites,
          'descriptions': description,
          'rolesAndResponsibilities': rolesAndResponsibilities,
          'experienceLevel': experienceLevel,
          'category': catagory,
          "workLocation": workLocation,
        },
      );
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData;
      } else {
        return null;
      }
    } catch (e) {
      // TODO
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
