import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/models/JobPostPageData.dart';
import 'package:health_app/util/components.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JobPostPage.dart';

class CompanyJobs extends StatefulWidget {
  CompanyJobs({Key? key, this.id}) : super(key: key);
  final id;
  @override
  State<CompanyJobs> createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  bool _bookmarked = false;
  bool notFound = false;
  String formattedDate = "";
  Map<String, dynamic> job = {};
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJob();
  }

  void fetchJob() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await getSpecificJob(widget.id);
      if (data != null) {
        setState(() {
          job = data as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          notFound = true;
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        notFound = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (job["Deadline"] is DateTime) {
      // It's a DateTime
      formattedDate = DateFormat('MMMM dd, y').format(job["Deadline"]);
    } else if (job["Deadline"] is String) {
      // It's a String
      final createdDateTime = DateTime.parse(job["Deadline"]);
      formattedDate = DateFormat('MMMM dd, y').format(createdDateTime);
    } else {
      formattedDate = "";
    }

    final width = MediaQuery.of(context).size.width - 40;
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else if (notFound) {
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
                  fetchJob();
                },
                label: 'Try Again',
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    showDialog(
                        //JobID:
                        context: context,
                        builder: (BuildContext context) {
                          return UpdateForm(
                            JobID: job['JobID'],
                            func: fetchJob,
                            job: job,
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 28,
                  )),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 25, right: 15),
          children: [
            Row(
              children: [
                Flexible(
                  flex: 10,
                  child: SvgPicture.asset(
                    'assets/images/image2vector.svg',
                    height: 60,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "${job["JobPosition"]}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Company name',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              '${job["NumberOfEmployees"]} Employees Needed',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width / 2 - 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headlines(
                        text: 'Deadline',
                      ),
                      Text(
                        "${formattedDate}",
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width / 2 - 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Headlines(text: 'Job Type', end: true),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(43, 186, 31, 1),
                              Color.fromRGBO(41, 230, 1, 1),
                            ],
                          ),
                        ),
                        child: Text(
                          "${job["JobType"]}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width / 2 - 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headlines(
                        text: 'Salary Range',
                      ),
                      Text(
                        "${job["Salary"]}",
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: width / 2 - 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Headlines(
                        text: 'Catagory',
                      ),
                      Text(
                        "${job["Category"]}",
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Headlines(text: 'Prerequites'),
            Description(content: "${job["Prerequisites"]}"),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Job Description',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Description(
              content: "${job["Descriptions"]}",
            ),
            const SizedBox(
              height: 25,
            ),
            const Headlines(text: 'Roles and Responsibilities'),
            Description(
              content: "${job["RolesAndResponsibilities"]}",
            ),
            // SvgPicture.asset('assets/images/image2vector.svg'),
          ],

          // ]),
        ),
      );
    }
  }
}

class Description extends StatefulWidget {
  const Description({super.key, this.content});
  final content;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool _isReadmore = false;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.content,
            overflow:
                _isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
            maxLines: _isReadmore ? null : 5,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isReadmore = !_isReadmore;
              });
            },
            child: Row(
              children: [
                Text(
                  _isReadmore ? 'read less' : 'read more',
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.blue),
                ),
                if (_isReadmore)
                  const Icon(
                    Icons.arrow_drop_up_sharp,
                    color: Colors.blue,
                  )
                else
                  const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.blue,
                  )
              ],
            ),
          )
        ],
      );
}

class UpdateForm extends StatefulWidget {
  const UpdateForm({
    super.key,
    required this.JobID,
    required this.func,
    required this.job,
  });
  final JobID;
  final func;
  final job;

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  Map<String, dynamic>? data = {};
  @override
  void initState() {
    super.initState();
    data?['jobPosition'] = widget.job['JobPosition'];
    data?['salary'] = widget.job['Salary'];
    data?['deadline'] = widget.job['Deadline'] is String
        ? DateTime.parse(widget.job['Deadline'])
        : widget.job['Deadline'];
    data?['jobType'] = widget.job['JobType'];
    data?['numberOfEmployees'] = "${widget.job['NumberOfEmployees']}";
    data?['prerequisites'] = widget.job['Prerequisites'];
    data?['descriptions'] = widget.job['Descriptions'];
    data?['rolesAndResponsibilities'] = widget.job['RolesAndResponsibilities'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(widget.job);
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
                try {
                  data?['salary'] =
                      int.parse(data?['salary'].replaceAll(',', ''));
                  data?['organizationId'] = await getIdOfUser();
                  final format = NumberFormat("#,###");
                  final Dateformat = DateFormat('yyyy-MM-dd');
                  data?['deadline'] = Dateformat.format(data?['deadline']);
                  data?['salary'] = "${format.format(data?['salary'])}";
                  final response = await UpdateJobPost(data, widget.JobID);
                  if (response != null) {
                    Navigator.of(context, rootNavigator: true).pop();
                    successSnackbar(context, text: response['message']);
                    widget.func();
                  } else {
                    showSnackbar(context,
                        text: 'Failed to Uodate job, Please try again');
                  }
                } catch (e) {
                  // TODO
                  print(e);
                  Navigator.of(context, rootNavigator: true).pop();
                  showSnackbar(context,
                      text: 'Failed to Update job, Please try again');
                }
              },
              label: 'Update Job',
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(top: 10),
          elevation: 0,
          scrollable: true,
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.only(bottom: 10),
          title: Text(
            "Update Job",
          ),
          content: Column(
            children: [
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Job Position",
                    placeHolder: "Job Position",
                    initialValue: widget.job['JobPosition'],
                    update: (value) {
                      data?['jobPosition'] = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Salary",
                    placeHolder: "Salary",
                    initialValue: widget.job['Salary'],
                    isPhone: true,
                    update: (value) {
                      data?['salary'] = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: DatePicker(
                    placeHolder: 'Deadline',
                    inputLabel: 'Deadline',
                    initialValue: widget.job['Deadline'],
                    update: (value) {
                      data?['deadline'] = value;
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
                  initialValue: widget.job['JobType'],
                  update: (value) {
                    data?['jobType'] = value;
                  },
                ),
              ),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Amount of Employees Needed",
                    placeHolder: "Number of Employee Needed",
                    isPhone: true,
                    initialValue: "${widget.job['NumberOfEmployees']}",
                    update: (value) {
                      data?['numberOfEmployees'] = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Prerequisites",
                    placeHolder: "Prerequisites",
                    initialValue: widget.job['Prerequisites'],
                    update: (value) {
                      data?['prerequisites'] = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Description",
                    initialValue: widget.job['Descriptions'],
                    placeHolder: "Description",
                    update: (value) {
                      data?['descriptions'] = value;
                    },
                  )),
              WidgetSpace(
                  space: 10,
                  child: InputBox(
                    inputLabel: "Roles and Responsibilities",
                    placeHolder: "Roles and Responsibilities",
                    initialValue: widget.job['RolesAndResponsibilities'],
                    update: (value) {
                      data?['rolesAndResponsibilities'] = value;
                    },
                  )),
            ],
          )),
    );
  }
}
