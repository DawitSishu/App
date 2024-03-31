import 'package:flutter/material.dart';
import 'package:health_app/Pages/HealthProfessionalHomePage.dart';
import 'package:health_app/Pages/JobDetailsPage.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/util/components.dart';

class HealthProfessionalBookmarks extends StatefulWidget {
  final List<dynamic>? jobs;
  const HealthProfessionalBookmarks({Key? key, this.jobs}) : super(key: key);

  @override
  State<HealthProfessionalBookmarks> createState() =>
      _HealthProfessionalBookmarksState();
}

class _HealthProfessionalBookmarksState
    extends State<HealthProfessionalBookmarks> {
  List<dynamic>? bookmarks = [];
  bool error = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final lists = await getAllBookmarkedProJobs();
    if (lists != null) {
      final bookmarkedJobIDs =
          lists.map((bookmark) => bookmark["jobId"]).toList();
      final jobsToKeep = widget.jobs
          ?.where((job) => bookmarkedJobIDs.contains(job["JobID"]))
          .toList();
      if (jobsToKeep != null) {
        bookmarks = jobsToKeep;
        for (var idx = 0;
            idx < bookmarks!.length && idx < lists.length;
            idx++) {
          bookmarks![idx]['id'] = lists[idx]['id'];
        }
      }
      setState(() {
        isLoading = false;
      });
    }
    // print(bookmarks?[0]);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.jobs);
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
    } else if (bookmarks!.length > 0) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.bookmark_outline,
            size: 25,
            color: Colors.blue.shade800,
          ),
          title: Text(
            'Bookmarks',
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
                  itemCount: bookmarks?.length ??
                      0, // Use null-aware operator to handle null bookmarks list
                  itemBuilder: (context, index) {
                    if (bookmarks == null || index >= bookmarks!.length) {
                      // Handle the case where bookmarks is null or index is out of bounds
                      return Container(); // Return an empty container or some placeholder widget
                    }

                    return GestureDetector(
                      onTap: () {
                        print(bookmarks?[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetails(
                              job: bookmarks?[index],
                              bookmarked: true,
                            ),
                          ),
                        );
                      },
                      child: JobInfoCard(
                          status: "${bookmarks?[index]['status']}",
                          jobPosition: "${bookmarks?[index]['JobPosition']}",
                          jobType: "${bookmarks?[index]['JobType']}",
                          workLocation: "${bookmarks?[index]['WorkLocation']}",
                          jobSalary: "${bookmarks?[index]['Salary']}",
                          showIcon: false),
                    );
                  })
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text("You have no Bookmarks."),
          ));
    }
  }
}
