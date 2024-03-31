import 'package:flutter/material.dart';
import 'package:health_app/Pages/HealthProfessionalHomePage.dart';
import 'package:health_app/Pages/JobDetailsPage.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/util/components.dart';

class JobApplications extends StatefulWidget {
  JobApplications({Key? key}) : super(key: key);

  @override
  State<JobApplications> createState() => _JobApplicationsState();
}

class _JobApplicationsState extends State<JobApplications> {
  List<dynamic>? jobs = [];
  List<dynamic>? Applications = [];
  bool isLoading = true;
  bool error = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final lists = await getAllAppliedJobs();
      if (lists != null) {
        final uniqueJobInfoSet = Set<int>();
        final applieddJobs = <Map<String, dynamic>>[];

        for (var applied in lists) {
          final jobInfo = applied["JobInfo"];

          if (jobInfo is Map<String, dynamic> &&
              !uniqueJobInfoSet.contains(jobInfo['JobID'])) {
            uniqueJobInfoSet.add(jobInfo['JobID']);
            applieddJobs.add(jobInfo);
          }
        }
        Applications = applieddJobs;
        setState(() {
          isLoading = false;
          error = false;
        });
      }
    } catch (e) {
      // TODO
      setState(() {
        isLoading = false;
        error = true;
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
          )); // Show a loading indicator or handle null data
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
    } else if (Applications!.length > 0) {
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
            'Applied Jobs',
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
                  itemCount: Applications?.length ??
                      0, // Use null-aware operator to handle null bookmarks list
                  itemBuilder: (context, index) {
                    if (Applications == null || index >= Applications!.length) {
                      // Handle the case where bookmarks is null or index is out of bounds
                      return Container(); // Return an empty container or some placeholder widget
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return JobDetails(
                                job: Applications?[index],
                              );
                            },
                          ),
                        );
                      },
                      child: JobInfoCard(
                        status: "${Applications?[index]['status']}",
                        jobPosition: "${Applications?[index]['JobPosition']}",
                        jobType: "${Applications?[index]['JobType']}",
                        workLocation: "${Applications?[index]['WorkLocation']}",
                        jobSalary: "${Applications?[index]['Salary']}",
                        showIcon: false,
                      ),
                    );
                  })
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text("You have no Applications."),
        ),
      );
    }
  }
}
