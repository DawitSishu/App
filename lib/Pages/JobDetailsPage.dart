import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/util/components.dart';
import 'package:intl/intl.dart';

class JobDetails extends StatefulWidget {
  final job;
  bool bookmarked;

  JobDetails({Key? key, this.job = Null, this.bookmarked = false})
      : super(key: key);
  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  String Label = '';
  bool error = false;
  bool isLoading = false;

  void checkJob() async {
    setState(() {
      isLoading = true;
    });
    try {
      final res = await CheckJobApplications(widget.job['JobID']);
      if (res == true) {
        setState(() {
          Label = 'Apply Now';
          error = false;
        });
      } else if (res == false) {
        setState(() {
          Label = '';
          error = false;
        });
      } else {
        setState(() {
          Label = '';
          error = true;
        });
      }
    } catch (e) {
      // TODO
      setState(() {
        Label = '';
        error = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkJob();
  }

  @override
  Widget build(BuildContext context) {
    final createdDateTime = DateTime.parse(widget.job["Created_at"] ?? "");
    final formattedDate = DateFormat('MMMM dd, y').format(createdDateTime);
    final deadlineDate = DateTime.parse(widget.job["Deadline"] ?? "");
    final formattedDeadline = DateFormat('MMMM dd, y').format(deadlineDate);
    final width = MediaQuery.of(context).size.width - 40;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
                  checkJob();
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
                onPressed: () async {
                  if (!widget.bookmarked) {
                    final response = await BookmarkAJob(widget.job["JobID"]);
                    if (response != null) {
                      successSnackbar(context, text: response["message"]);
                      setState(() {
                        widget.bookmarked = true;
                      });
                    } else {
                      showSnackbar(context,
                          text: 'Failed to Bookmark job, Please try Again.');
                    }
                  } else {
                    bool confirm = await showConfirmationDialog(
                      context,
                      'Confirm Delete Bookmark',
                      'Are you sure you want to Delete Job from Bookmarks?',
                    );
                    if (confirm) {
                      final response =
                          await DeleteBookmarkedJob(widget.job["id"]);
                      if (response != null) {
                        successSnackbar(context, text: response["message"]);
                        setState(() {
                          widget.bookmarked = false;
                        });
                      } else {
                        return;
                      }
                    } else {
                      showSnackbar(context,
                          text:
                              'Failed to Remove Bookmarked job, Please try Again.');
                    }
                  }
                },
                icon: widget.bookmarked
                    ? const Icon(
                        Icons.bookmark_outline,
                        color: Colors.green,
                        size: 28,
                      )
                    : const Icon(
                        Icons.bookmark_outline,
                        color: Colors.grey,
                        size: 28,
                      ),
              ),
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
              "${widget.job["JobPosition"]}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // const Text(
            //   'Company name',
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.grey,
            //   ),
            // ),
            Text(
              "${formattedDate}",
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
                        text: 'Apply Before',
                      ),
                      Text(
                        "${formattedDeadline}",
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
                      // const Headlines(text: 'Job Location', end: true),
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
                          "Job Location",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.job["WorkLocation"]}",
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                      ),
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
                        text: 'Salary',
                      ),
                      Text(
                        "${widget.job["Salary"]}",
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Headlines(text: 'Job Nature', end: true),
                      Text(
                        "${widget.job["JobType"]}",
                        textAlign: TextAlign.end,
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
              content: "${widget.job["Descriptions"]}",
            ),
            const SizedBox(
              height: 25,
            ),
            const Headlines(text: 'Job Prerequisites'),
            Description(
              content: "${widget.job["Prerequisites"]}",
            ),
            const SizedBox(
              height: 25,
            ),
            const Headlines(text: 'Roles and Responsibilities'),
            Description(
              content: "${widget.job["RolesAndResponsibilities"]}",
            ),
            // SvgPicture.asset('assets/images/image2vector.svg'),
          ],

          // ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Label.isNotEmpty
            ? CustomButton(
                onPressed: () async {
                  bool confirm = await showConfirmationDialog(
                    context,
                    'Confirm Job Application',
                    'Are you sure you want to apply to this job?',
                  );
                  if (confirm) {
                    final response = await ApplyToJob(widget.job["JobID"]);
                    if (response != null) {
                      successSnackbar(context, text: response["message"]);
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      showSnackbar(context,
                          text: 'Failed to Apply to job, Please try Again.');
                    }
                  } else {
                    return;
                  }
                },
                label: 'Apply Now',
              )
            : null,
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
