import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Pages/HealthProfessionalHomePage.dart';
import 'package:health_app/Pages/companyJobsPage.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/models/JobPostPageData.dart';
import 'package:health_app/util/components.dart';

class JobPost extends StatefulWidget {
  const JobPost({super.key});

  @override
  State<JobPost> createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  bool isLoading = true;
  bool error = false;
  List<dynamic>? Jobs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // void updateJobs(PostedJobData data) {
  //   setState(() {
  //     Jobs?.add(data);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // get the id from the prefss
      // final userId = prefs.getString('userId');
      // final userId = 2;
      fetchData();
    });
  }

  void fetchData() async {
    try {
      Jobs = await getPostedJobs();
      if (Jobs != null) {
        setState(() {
          isLoading = false;
          error = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = true;
        });
      }
    } catch (e) {
      // TODO
      setState(() {
        error = true;
        isLoading = false;
      });
    }
  }

  void deleteJob(id) async {
    try {
      setState(() {
        isLoading = true;
      });
      final confirm = await showConfirmationDialog(
        context,
        'Confirm Delete',
        'Are you sure you want to Delete this Job?',
      );
      if (confirm) {
        final response = await DeletePostedJob(id);
        if (response != null) {
          Jobs?.removeWhere((job) => job['JobID'] == id);
          successSnackbar(context, text: response["message"]);
        } else {
          showSnackbar(context,
              text: 'Failed to Delete Job, Please try Again.');
        }
        setState(() {
          isLoading = false;
        });
      } else {
        return;
      }
    } catch (e) {
      // TODO
      setState(() {
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
    }
    {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.work_outline,
            size: 25,
            color: Colors.blue.shade800,
          ),
          title: Text(
            'Jobs Posted',
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
                  itemCount: Jobs?.length,
                  itemBuilder: (context, index) {
                    final job = Jobs?[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompanyJobs(
                              id: job["JobID"],
                            ),
                          ),
                        );
                      },
                      child: OrgJobInfoCard(
                        jobPosition: "${job['JobPosition']}",
                        jobType: "${job['JobType']}",
                        workLocation: "${job['WorkLocation']}",
                        jobSalary: "${job['Salary']}",
                        displayedIcon: Icons.delete,
                        iconColor: Colors.red,
                        onclick: () {
                          deleteJob(job['JobID']);
                        },
                      ),
                    );
                  },
                ),
              ]),
        ),
        floatingActionButton: SizedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertForm(
                      updateJobs: (data) {
                        fetchData();
                      },
                      buttonText: 'Post New Job',
                    );
                    // );
                  })
            },
            tooltip: 'Increment',
            child: Ink(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color.fromARGB(255, 36, 107, 253),
                    const Color.fromARGB(255, 80, 137, 255)
                  ],
                ),
              ),
              child: const Icon(
                Icons.add,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class AlertForm extends StatefulWidget {
  final updateJobs;
  final buttonText;
  final updating;
  const AlertForm(
      {super.key,
      required this.updateJobs,
      required this.buttonText,
      this.updating = false});

  @override
  State<AlertForm> createState() => _AlertFormState();
}

class _AlertFormState extends State<AlertForm> {
  PostedJobData data = new PostedJobData();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(
            color: const Color.fromRGBO(42, 114, 205, 0.4),
            blurRadius: 4,
            offset: const Offset(0, 3),
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(20, 35, 20, 35),
      padding: EdgeInsets.all(0),
      child: AlertDialog(
          actions: [
            CustomButton(
              onPressed: () async {
                if (!widget.updating) {
                  if (data.checkJobData()) {
                    // Navigator.of(context, rootNavigator: true).pop();
                    showSnackbar(context, text: 'Please Include ALL Fields!!');
                    return;
                  }
                  // Navigator.of(context, rootNavigator: true).pop();
                  // print(data);
                  // widget.updateJobs(data.pintPostedJobData());

                  final response = await data.sendData();
                  print(response);
                  if (response != null) {
                    widget.updateJobs(data.pintPostedJobData());
                    Navigator.of(context, rootNavigator: true).pop();
                  } else {
                    showSnackbar(context,
                        text: 'Failed to post job, Please try again');
                  }
                }
              },
              label: 'Post Job',
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(top: 10),
          elevation: 0,
          scrollable: true,
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.only(bottom: 10),
          title: Text(
            widget.buttonText,
          ),
          content: Column(
            children: [
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Job Position",
                    placeHolder: "Job Position",
                    update: (value) {
                      data.jobPosition = value;
                    },
                  )),
              WidgetSpace(
                space: 10,
                child: SingleSelectDropDownBtn(
                  items: const [
                    'Orthoptist',
                    'Therapist',
                    'Nurse',
                  ],
                  label: 'Catagory',
                  update: (value) {
                    data.catagory = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: SingleSelectDropDownBtn(
                  items: const [
                    'No Experience',
                    '1 - 5 Years',
                    '6 - 10 Years',
                    'More than 10 Years'
                  ],
                  label: 'Work Experience (Years)',
                  update: (value) {
                    data.experienceLevel = value;
                  },
                ),
              ),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Work Location",
                    placeHolder: "Work Location",
                    update: (value) {
                      data.workLocation = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Salary",
                    placeHolder: "Salary",
                    isPhone: true,
                    update: (value) {
                      data.salary = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: DatePicker(
                    placeHolder: 'Deadline',
                    inputLabel: 'Deadline',
                    update: (value) {
                      data.deadline = value;
                    },
                  )),
              WidgetSpace(
                space: 10,
                child: SingleSelectDropDownBtn(
                  items: const [
                    "Full Time",
                    "Part Time",
                    "Remote",
                    "Contractual(One Time Only)"
                  ],
                  label: 'Job Type',
                  update: (value) {
                    data.jobType = value;
                  },
                ),
              ),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Amount of Employees Needed",
                    placeHolder: "Number of Employee Needed",
                    isPhone: true,
                    update: (value) {
                      data.numberOfEmployees = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Prerequisites",
                    placeHolder: "Prerequisites",
                    update: (value) {
                      data.prerequisites = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Description",
                    placeHolder: "Description",
                    update: (value) {
                      data.description = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Roles and Responsibilities",
                    placeHolder: "Roles and Responsibilities",
                    update: (value) {
                      data.rolesAndResponsibilities = value;
                    },
                  )),
            ],
          )),
    );
  }
}

class OrgJobInfoCard extends StatefulWidget {
  const OrgJobInfoCard({
    Key? key,
    this.displayedIcon = Icons.bookmark_border,
    this.iconColor = Colors.grey,
    this.isBookmark = false,
    this.jobPosition = '',
    this.jobType = '',
    this.workLocation = '',
    this.jobSalary = '',
    this.showIcon = true,
    this.onclick = null,
  }) : super(key: key);

  final displayedIcon;
  final iconColor;
  final isBookmark;
  final jobPosition;
  final jobType;
  final workLocation;
  final jobSalary;
  final showIcon;
  final onclick;

  @override
  State<OrgJobInfoCard> createState() => _OrgJobInfoCardState();
}

class _OrgJobInfoCardState extends State<OrgJobInfoCard> {
  late Color iconColor;
  late IconData displayedIcon;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    iconColor = widget.iconColor;
    displayedIcon = widget.displayedIcon;
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 5, bottom: 5),
        // height: 170,
        child: Card(
          elevation: 3,
          // margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromRGBO(200, 200, 200, 0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset('assets/images/image2vector.svg'),
                    ),
                    // Icon(Icons.bookmark_border)
                    if (widget.showIcon)
                      InkWell(
                        onTap: () {
                          selected = !selected;
                          print(selected && !widget.isBookmark);
                          setState(() {});
                          if (widget.onclick != null) {
                            widget.onclick();
                          }
                        },
                        child: Icon(
                          displayedIcon,
                          color: selected && !widget.isBookmark
                              ? const Color.fromRGBO(17, 160, 0, 1)
                              : iconColor,
                        ),
                      )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    widget.jobPosition,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  widget.jobType,
                  style: TextStyle(color: Colors.grey, fontSize: 11.5),
                ),
                Text(
                  widget.workLocation,
                  style: TextStyle(color: Colors.grey, fontSize: 11.5),
                ),
                Text(
                  widget.jobSalary,
                  style: TextStyle(color: Colors.grey, fontSize: 11.5),
                )
              ],
            ),
          ),
        ),
      );
}
