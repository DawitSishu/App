import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:health_app/models/JobPostPageData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String orgToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidHlwZSI6Im9yZ2FuaXphdGlvbiIsInBheW1lbnRTdGF0dXMiOiJwYWlkIiwiaWF0IjoxNjk4MzI1MzU1fQ.CjKweU2z8fgPsOYb039jWUqfVuOcNnDQhKyC12FTWJU";

String proToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidHlwZSI6InByb2Zlc3Npb25hbCIsInBheW1lbnRTdGF0dXMiOiJwYWlkIiwiaWF0IjoxNjk4MjIxNjU3fQ.eqMpRALI0aLUzUBZvEBal_yzqO8txq8AtTjJuuF-l40";

Future<dynamic> completeRegistration() async {
  try {
    final userId = await getId();
    final token = await getToken();
    final url =
        Uri.http('196.188.127.211:10000', '/update-profile-status/$userId');
    final body = {
      'profileCreationStatus': 'completed',
    };
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );
    print("G");
    // final bod = json.decode(response);
    print("val $token $userId ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'error': {}};
    } else {
      return {
        'success': false,
        'error': 'Failed, please check internet connection and try again'
      };
    }
  } catch (e) {
    return {'success': false, 'error': e};
  }
}

logOut() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('userType');
  await prefs.remove('userId');
  await prefs.remove('id');
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String?> getId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

Future<int?> getIdOfUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('id');
}

Future<List<dynamic>?> getAllJobs() async {
  try {
    final token = await getToken();

    final url = Uri.http('196.188.127.211:10000', '/professional/job-posts');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<List<dynamic>?> getAllProfessionals() async {
  try {
    final token = await getToken();

    final url = Uri.http('196.188.127.211:10000', 'organization/professionals');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<Map<String, dynamic>?> getProfessional(int id) async {
  try {
    final token = await getToken();

    final url =
        Uri.http('196.188.127.211:10000', 'organization/professional/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData['data'] is List<dynamic>) {
        final dataList = decodedData['data'] as List<dynamic>;
        if (dataList.isNotEmpty) {
          return dataList[0] as Map<String, dynamic>;
        }
      }
    }
    return null;
  } catch (e) {
    // TODO
    return null;
  }
}

Future<List<dynamic>?> getPostedJobs() async {
  try {
    final token = await getToken();
    final orgID = await getIdOfUser();

    final url =
        Uri.http('196.188.127.211:10000', '/organization/my-jobs/all/$orgID');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<List<dynamic>?> getAllBookmarkedProJobs() async {
  try {
    final token = await getToken();

    final url = Uri.http('196.188.127.211:10000', '/professional/bookmarks');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<Map<String, dynamic>?> ApplyToJob(jobId) async {
  try {
    final token = await getToken();
    final proId = await getIdOfUser();
    final url = Uri.http('196.188.127.211:10000', '/professional/apply');
    final response = await http.post(
      url,
      body: {'professionalId': "$proId", 'jobId': "$jobId"},
      headers: {'Authorization': 'Bearer $token'},
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
    print(e);
    return null;
  }
}

Future<Map<String, dynamic>?> BookmarkAJob(jobId) async {
  try {
    final token = await getToken();
    final proId = await getIdOfUser();

    final url = Uri.http('196.188.127.211:10000', '/professional/bookmark');
    final response = await http.post(
      url,
      body: {'professionalId': "$proId", 'jobId': "$jobId"},
      headers: {'Authorization': 'Bearer $token'},
    );
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

Future<Map<String, dynamic>?> DeleteBookmarkedJob(id) async {
  try {
    final token = await getToken();

    final url = Uri.http('196.188.127.211:10000', '/professional/bookmark/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
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

Future<List<dynamic>?> getAllAppliedJobs() async {
  try {
    final token = await getToken();

    final url = Uri.http('196.188.127.211:10000', '/professional/my-applied');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future ProfessionalPersonalDetail() async {
  try {
    final token = await getToken();
    // final proId = await getId();
    int? id = await getIdOfUser();

    // final url0 = Uri.http('196.188.127.211:10000', '/professional/all');
    // final pros = await http.get(
    //   url0,
    //   headers: {'Authorization': 'Bearer $token'},
    // );
    // if (pros.statusCode == 200) {
    //   final decodedData = json.decode(pros.body);
    //   for (var user in decodedData['data']) {
    //     final parsedProId = int.tryParse(proId!);
    //     if (parsedProId != null && user['user_id'] == parsedProId) {
    //       id = user['id'];
    //     }
    //   }
    //   if (id == 0) {
    //     return null;
    //   }
    // } else {
    //   return null;
    // }

    final url =
        Uri.http('196.188.127.211:10000', '/professional/personal-info/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'][0] ?? [];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<Map<String, dynamic>?> UpdateProfessionalProfile(
    Map<String, dynamic> data) async {
  try {
    final token = await getToken();
    final proId = await getIdOfUser();

    final jsonString = json.encode(data);
    final url =
        Uri.http('196.188.127.211:10000', '/professional/personal-info/$proId');
    final response = await http.put(
      url,
      body: jsonString,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
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

Future<List<dynamic>?> getJobApplicants() async {
  try {
    final token = await getToken();
    final orgId = await getIdOfUser();
    final url =
        Uri.http('196.188.127.211:10000', '/organization/applied/$orgId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<Map<String, dynamic>?> InstitutionDetail() async {
  try {
    final token = await getToken();
    final orgId = await getIdOfUser();
    final url = Uri.http(
        '196.188.127.211:10000', '/organization/organization-info/$orgId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future<Map<String, dynamic>?> UpdateOrgProfile(data) async {
  try {
    final token = await getToken();
    final orgId = await getIdOfUser();

    final url = Uri.http(
        '196.188.127.211:10000', '/organization/organization-info/$orgId');
    final response = await http.put(
      url,
      body: data,
      headers: {'Authorization': 'Bearer $token'},
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

Future<Map<String, dynamic>?> DeletePostedJob(id) async {
  try {
    final token = await getToken();

    final url =
        Uri.http('196.188.127.211:10000', '/organization/job-posts/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
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

Future UpdateJobPost(data, jobID) async {
  try {
    final token = await getToken();

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final jsonBody = json.encode(data);

    final url =
        Uri.http('196.188.127.211:10000', '/organization/my-jobs/$jobID');
    final response = await http.put(
      url,
      body: jsonBody,
      headers: headers,
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

Future SearchJobPosts(term) async {
  try {
    final token = await getToken();

    final url = Uri.http(
      '196.188.127.211:10000',
      '/professional/job-post/simpleSearch',
      {'q': Uri.encodeQueryComponent(term)},
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print(json.decode(response.body));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future getSpecificJob(id) async {
  try {
    final token = await getToken();
    final url = Uri.http('196.188.127.211:10000', '/organization/my-jobs/$id');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future FilterJobPosts(term) async {
  try {
    final token = await getToken();

    final url = Uri.http(
      '196.188.127.211:10000',
      '/professional/job-posts',
      {'category': Uri.encodeQueryComponent(term)},
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    print(json.decode(response.body));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future searchProfessionals(name) async {
  try {
    final token = await getToken();

    final url = Uri.http(
      '196.188.127.211:10000',
      '/organization/searchByName',
      {'name': Uri.encodeQueryComponent(name)},
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}

Future addTransactionID(transactionID) async {
  try {
    final id = await getId();
    final url = Uri.http(
      '196.188.127.211:10000',
      '/add-transaction-id/$id',
    );

    final response = await http.post(url, body: {
      "transaction_id": transactionID,
      "currentPaymentStatus": "pending"
    });

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

Future UploadProDocs(data) async {
  try {
    final token = await getToken();
    final proId = await getIdOfUser();

    final url = Uri.http(
      '196.188.127.211:10000',
      '/professional/documents/$proId',
    );

    final response = await http.post(
      url,
      body: data,
      headers: {'Authorization': 'Bearer $token'},
    );
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

Future UploadOrgDocs(data) async {
  try {
    final token = await getToken();
    final orgId = await getIdOfUser();

    final url = Uri.http(
      '196.188.127.211:10000',
      '/organization/documents/$orgId',
    );

    final response = await http.post(
      url,
      body: data,
      headers: {'Authorization': 'Bearer $token'},
    );
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

Future CheckJobApplications(id) async {
  try {
    final token = await getToken();
    final url = Uri.http(
      '196.188.127.211:10000',
      '/professional/check-application',
      {'jobId': Uri.encodeQueryComponent("$id")},
    );

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    final decodedData = json.decode(response.body);
    print(decodedData);
    if (decodedData['statusCode'] == 200) {
      return true;
    } else if (decodedData['statusCode'] == 400) {
      return false;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    // TODO
    return null;
  }
}

Future getJobApplications() async {
  try {
    final token = await getToken();
    final id = await getIdOfUser();

    final orgIdEncoded = Uri.encodeQueryComponent("$id");
    final uri = Uri.http('196.188.127.211:10000',
        '/organization/myJobPost/$orgIdEncoded/applicants');
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    final decodedData = json.decode(response.body);

    if (response.statusCode == 200) {
      return decodedData['data'];
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    print("error $e");
    return null;
  }
}

Future updateProfileStatus(status) async {
  try {
    final userID = await getId();

    if (status.isEmpty || status == null) {
      return null;
    }

    final url = Uri.http(
      '196.188.127.211:10000',
      '/update-profile-status',
      {'user_id': Uri.encodeQueryComponent("$userID")},
    );

    final response =
        await http.put(url, body: {"profileCreationStatus": "$status"});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  } catch (e) {
    // TODO
    return null;
  }
}
