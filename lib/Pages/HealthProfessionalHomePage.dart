import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Pages/HealthInstitutionHomePage.dart';
import 'package:health_app/Pages/HealthProfessionalBookmarkPage.dart';
import 'package:health_app/Pages/JobApplicationsPage.dart';
import 'package:health_app/Pages/personalSettingsPage.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:shimmer/shimmer.dart';

import '../util/components.dart';
import 'JobDetailsPage.dart';

class HealthProfessionalHome extends StatefulWidget {
  const HealthProfessionalHome({super.key});

  @override
  State<HealthProfessionalHome> createState() => _HealthProfessionalHomeState();
}

class _HealthProfessionalHomeState extends State<HealthProfessionalHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<Tab> myTabs = <Tab>[
    const Tab(
      icon: Icon(
        Icons.home_outlined,
        size: 27,
      ),
      child: Text(
        'Home',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.bookmark_outline,
        size: 27,
      ),
      child: Text(
        'Bookmark',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.work_history_outlined,
        size: 27,
      ),
      child: Text(
        'Applications',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.settings_outlined,
        size: 27,
      ),
      child: Text(
        'Settings',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    ),
  ];

  List<dynamic>? jobs;
  bool isLoading = true;

  //  = getAllJobs();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      jobs = await getAllJobs();
      if (jobs != null) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // } else {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          HomePage(
            tabController: tabController,
            // jobPostings: jobs ?? [],
          ),
          HealthProfessionalBookmarks(
            jobs: jobs,
          ),
          JobApplications(),
          PersonalSettings()
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 1.2, color: Color.fromARGB(50, 36, 107, 253))),
        ),
        child: TabBar(
          labelPadding: EdgeInsets.zero,
          controller: tabController,
          splashBorderRadius: BorderRadius.circular(40),
          labelColor: const Color.fromARGB(255, 36, 107, 253),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: const TextStyle(),
          tabs: myTabs,
        ),
      ),
    );
  }
}
// }

class RecentJobPosts extends StatelessWidget {
  final List<dynamic> jobList;
  const RecentJobPosts({super.key, required this.jobList});

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: jobList.length,
      itemBuilder: (context, index) {
        final job = jobList[index];
        return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // Create a new screen and pass data as arguments
                      return JobDetails(
                        job: job,
                      );
                    },
                  ),
                );
              },
              child: SizedBox(
                width: 280,
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 3,
                    // margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Color.fromRGBO(200, 200, 200, 0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 36, 107, 253),
                            Color.fromARGB(255, 80, 137, 255)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: SvgPicture.asset(
                                      'assets/images/image2vector.svg'),
                                ),
                                Text(
                                  "${job['Salary']}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                " ${job['JobPosition']}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              '${job['JobType']} - ${job['WorkLocation']}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Tag(
                                            text: "${job['ExperienceLevel']}",
                                            onSelectionChanged: (s) {},
                                            color: Colors.white
                                            // update: () {},
                                            // set: () {},
                                            ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Tag(
                                            text: "${job['JobType']}",
                                            onSelectionChanged: (s) {},
                                            color: Colors.white
                                            // update: () {},
                                            // set: () {},
                                            ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Tag(
                                            text: "${job['Category']}",
                                            onSelectionChanged: (s) {},
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  height: 40,
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: const Icon(
                                //     Icons.bookmark_border,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
      });
}

class JobInfoCard extends StatefulWidget {
  const JobInfoCard(
      {super.key,
      this.displayedIcon = Icons.bookmark_border,
      this.iconColor = Colors.grey,
      this.isBookmark = false,
      this.jobPosition = '',
      this.jobType = '',
      this.workLocation = '',
      this.jobSalary = '',
      this.status = '',
      this.inApplication = false,
      this.count = 0,
      this.showIcon = true});
  final displayedIcon;
  final iconColor;
  final isBookmark;
  final jobPosition;
  final jobType;
  final workLocation;
  final jobSalary;
  final showIcon;
  final inApplication;
  final count;
  final status;

  @override
  State<JobInfoCard> createState() => _JobInfoCardState();
}

class _JobInfoCardState extends State<JobInfoCard> {
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
                    if (widget.status.isNotEmpty)
                      Text("${widget.status}",
                          style: TextStyle(color: Colors.grey, fontSize: 12.5)),

                    // Icon(Icons.bookmark_border)
                    if (widget.showIcon)
                      InkWell(
                        onTap: () {
                          selected = !selected;
                          print(selected && !widget.isBookmark);
                          setState(() {});
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
                ),
                if (widget.inApplication)
                  Text("${widget.count} Applicants",
                      style: TextStyle(color: Colors.grey, fontSize: 11.5)),
              ],
            ),
          ),
        ),
      );
}

class Tag extends StatefulWidget {
  const Tag({
    Key? key,
    this.selected = false,
    required this.text,
    this.fontSize = 11.0,
    this.color = Colors.grey,
    this.textColor = const Color.fromARGB(255, 66, 97, 160),
    this.topPadding = 1.0,
    required this.onSelectionChanged,
  }) : super(key: key);

  final bool selected;
  final double fontSize;
  final Color textColor;
  final Color color;
  final String text;
  final double topPadding;
  final Function(bool) onSelectionChanged;

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool selected = false;
  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant Tag oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != selected) {
      setState(() {
        selected = widget.selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelectionChanged(!selected);
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8, widget.topPadding, 8, 1),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(43, 186, 31, 1),
                    Color.fromRGBO(41, 230, 1, 1),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(5),
          color: selected ? null : widget.color,
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: selected ? Colors.white : widget.textColor,
          ),
        ),
      ),
    );
  }
}

class TagOptions extends StatefulWidget {
  const TagOptions({
    Key? key,
    required this.tags,
    required this.onFilter,
    required this.jobFilterState,
  }) : super(key: key);

  final List<String> tags;
  final Function(String) onFilter;
  final JobFilterState jobFilterState;

  @override
  _TagOptionsState createState() => _TagOptionsState();
}

class _TagOptionsState extends State<TagOptions> {
  void handleTagSelection(String tag) {
    setState(() {
      widget.jobFilterState.selectedTag =
          tag == widget.jobFilterState.selectedTag ? 'All Jobs' : tag;
    });

    widget.onFilter(widget.jobFilterState.selectedTag);
  }

  @override
  Widget build(BuildContext context) => ListView(
        scrollDirection: Axis.horizontal,
        children: widget.tags
            .map(
              (tag) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Tag(
                  text: tag,
                  selected: tag == widget.jobFilterState.selectedTag,
                  onSelectionChanged: (isSelected) {
                    handleTagSelection(tag);
                  },
                  topPadding: 4,
                  textColor: Colors.white,
                ),
              ),
            )
            .toList(),
      );
}

class JobFilterState extends ChangeNotifier {
  String selectedTag = 'All Jobs';

  void updateSelectedTag(String tag) {
    selectedTag = tag;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final tabController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  bool error = false;
  List<dynamic> jobPostings = [];
  DateTime? currentBackPressTime;

  final JobFilterState _jobFilterState = JobFilterState();

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      final status = await showConfirmationDialog(
        context,
        'Confirm Close',
        'Are you sure you want to Close the app?',
      );
      return status ?? false;
    } else {
      await logOut();
      return true;
    }
  }

  void fetchJobs() async {
    final data = await getAllJobs();
    print(data);
    if (data != null) {
      setState(() {
        jobPostings = data;
        isLoading = false;
      });
    }
  }

  void searchJobs(term) async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await SearchJobPosts(term);
      if (data != null) {
        setState(() {
          jobPostings = data;
          isLoading = false;
          error = false;
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        isLoading = false;
      });
    }
  }

  void categorizeJobs(term) async {
    try {
      setState(() {
        isLoading = true;
      });
      String temp = '';
      if (term == 'All Jobs' || term == 'Other') {
        temp = '';
      } else {
        temp = term;
      }
      final data = await FilterJobPosts(temp);
      if (data != null) {
        setState(() {
          jobPostings = data;
          isLoading = false;
          error = false;
        });
        _jobFilterState.updateSelectedTag(term);
      }
    } catch (e) {
      // TODO
      setState(() {
        error = true;
      });
    }
  }

  void filterJobPostings(String searchTerm) {
    if (searchTerm.isEmpty) {
      fetchJobs();
    } else {
      searchJobs(searchTerm);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (error) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('Error: Please, Try Again')),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    fetchJobs();
                  },
                  label: 'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    } else if (jobPostings.length > 0) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ListView(
            // alignment: ,
            // alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello, ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Find Your Ideal Job',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue.shade900,
                              ),
                            )
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(144, 44, 44, 44),
                          foregroundColor: Colors.white,
                          radius: 25,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.person_rounded),
                              iconSize: 35,
                              onPressed: () {
                                widget.tabController.animateTo(3);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            // width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(50, 0, 0, 0),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String searchTerm = _searchController.text;
                                    filterJobPostings(searchTerm);
                                  },
                                ),
                                hintText: 'Search a Job',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                              onEditingComplete: () {
                                setState(() {
                                  isLoading = true;
                                });
                                String searchTerm = _searchController.text;
                                filterJobPostings(searchTerm);
                              },
                            ),
                          ),
                        ),
                        //to be repleced with the icon
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 36, 107, 253),
                                  Color.fromARGB(255, 80, 137, 255)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/images/config.svg',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Recent Job Posts',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  // Recent Job Posts
                  SizedBox(
                    height: 200,
                    child: RecentJobPosts(jobList: jobPostings),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    height: 25,
                    child: TagOptions(
                      jobFilterState: _jobFilterState,
                      tags: [
                        'All Jobs',
                        'Orthoptist',
                        'Therapist',
                        'Nurse',
                        "Medical",
                        'Other'
                      ],
                      onFilter: (term) {
                        categorizeJobs(term);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: jobPostings.length,
                      itemBuilder: (context, index) {
                        final job = jobPostings[index];
                        return GestureDetector(
                          child: SizedBox(
                            child: JobInfoCard(
                                status: "${job['status']}",
                                jobPosition: "${job['JobPosition']}",
                                jobType: "${job['JobType']}",
                                workLocation: "${job['WorkLocation']}",
                                jobSalary: "${job['Salary']}",
                                showIcon: false),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetails(
                                  job: job,
                                ),
                              ),
                            );
                          },
                        );
                      })
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              //
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('NO JOBS FOUND')),
              SizedBox(height: 20),
              Center(
                child: CustomButton(
                  onPressed: () async {
                    fetchJobs();
                  },
                  label: 'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
