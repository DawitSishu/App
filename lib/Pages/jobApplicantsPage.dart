import 'package:flutter/material.dart';
import 'package:health_app/Pages/HealthProfessionalHomePage.dart';
import 'package:health_app/Pages/JobAppliedProfessionals.dart';
import 'package:health_app/Services/general-controller.dart';

import '../util/components.dart';

class JobApplicants extends StatefulWidget {
  const JobApplicants({super.key});

  @override
  State<JobApplicants> createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  List<dynamic>? applicants = [];
  List<dynamic>? finalApplicants = [];
  bool isLoading = true;
  bool error = true;
  @override
  void initState() {
    super.initState();
    fetchData();
    // getJobApplications();
  }

  Future<void> fetchData() async {
    try {
      // final lists = await getJobApplicants();
      // final lists = await getJobApplications();
      // if (lists != null) {
      //   applicants = lists;
      //   for (var i = 0; i < applicants!.length; i++) {
      //     final job = applicants?[i];

      //     // Set to keep track of unique applicant IDs within the current item
      //     Set<int> uniqueApplicantIds = Set();

      //     // Remove duplicates from "Applicants" array based on ID
      //     final uniqueApplicants = <Map<String, dynamic>>[];
      //     job['Applicants'].forEach((applicant) {
      //       if (!uniqueApplicantIds.contains(applicant['id'])) {
      //         uniqueApplicantIds.add(applicant['id']);
      //         uniqueApplicants.add(applicant);
      //       }
      //     });
      //     // Update "Applicants" array and "ApplicantCount"
      //     job['Applicants'] = uniqueApplicants;
      //     job['ApplicantCount'] = uniqueApplicants.length;
      //   }

      //   // finalApplicants = processApplicants(applicants);
      //   setState(() {
      //     isLoading = false;
      //     error = false;
      //   });
      // }
      final lists = await getJobApplications();
      if (lists != null) {
        applicants = lists
            .where((job) => (job['Applicants'] as List).isNotEmpty)
            .toList();

        for (var i = 0; i < applicants!.length; i++) {
          final job = applicants?[i];

          // Set to keep track of unique applicant IDs within the current item
          Set<int> uniqueApplicantIds = Set();

          // Remove duplicates from "Applicants" array based on ID
          final uniqueApplicants = <Map<String, dynamic>>[];
          job['Applicants'].forEach((applicant) {
            if (!uniqueApplicantIds.contains(applicant['id'])) {
              uniqueApplicantIds.add(applicant['id']);
              uniqueApplicants.add(applicant);
            }
          });

          // Update "Applicants" array and "ApplicantCount"
          job['Applicants'] = uniqueApplicants;
          job['ApplicantCount'] = uniqueApplicants.length;
        }

        setState(() {
          isLoading = false;
          error = false;
        });
      }
    } catch (e) {
      // TODO
      print(e);
      setState(() {
        error = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else if (error) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Error: Please, Try Again')),
            SizedBox(height: 20),
            Center(
              child: CustomButton(
                onPressed: () async {
                  fetchData();
                },
                label: 'Try Again',
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.work_history_outlined,
            size: 25,
            color: Colors.blue.shade800,
          ),
          title: Text(
            'Job Applications',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.blue.shade900,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              children: [
                const SizedBox(
                  height: 15,
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: applicants?.length,
                  itemBuilder: (context, index) {
                    final job = applicants?[index];
                    return GestureDetector(
                      onTap: () async {
                        final pros = job?['Applicants'];
                        if (pros != null && pros.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobApplicantProfessionals(
                                pros: pros,
                              ),
                            ),
                          );
                        } else {
                          return;
                          // showSnackbar(context,
                          //     text:
                          //         "Failed TO Get Professionals, Please Try Again.");
                        }
                      },
                      child: JobInfoCard(
                        jobPosition: "${job!['JobPosition']}",
                        jobType: "${job['JobType']}",
                        workLocation: "${job['WorkLocation']}",
                        jobSalary: "${job['Salary']}",
                        showIcon: false,
                        inApplication: true,
                        count: job['ApplicantCount'],
                        status: job['status'],

                        // displayedIcon: Icons.delete,
                        // iconColor: Colors.red,
                      ),
                    );
                  },
                ),
              ]),
        ),
      );
    }
  }
}
