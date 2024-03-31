import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Pages/JobPostPage.dart';
import 'package:health_app/Pages/errorWidget.dart';
import 'package:health_app/Pages/institutionSettingsPage.dart';
import 'package:health_app/Pages/jobApplicantsPage.dart';
import 'package:health_app/Pages/proffesionalDetailsPage.dart';
import 'package:health_app/Services/general-controller.dart';

import '../util/components.dart';

class HealthInstitutionHome extends StatefulWidget {
  const HealthInstitutionHome({super.key});

  @override
  State<HealthInstitutionHome> createState() => _HealthInstitutionHomeState();
}

class _HealthInstitutionHomeState extends State<HealthInstitutionHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<dynamic>? professionals;
  bool isLoading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      professionals = await getAllProfessionals();
      if (professionals != null) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() async {
    if (!tabController.indexIsChanging) {
      setState(() {
        error = null;
        isLoading = false;
      });
    }
    if (tabController.index == 0) {
      // Handle the error for the "Home" tab (assuming this is where you load data)
      try {
        // Load data for the "Home" tab
        professionals = await getAllProfessionals();
        if (professionals != null) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'An error occurred: Try again';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          error = 'An error occurred: $e';
          isLoading = false;
        });
      }
    }
  }

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
          fontSize: 11,
        ),
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.work_outline,
        size: 27,
      ),
      child: Text(
        'Job posts',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          fontSize: 11,
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
          fontSize: 11,
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
          fontSize: 11,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomErrorWidget(
          errorMessage: error,
          onRetry: () {
            setState(() {
              error = null; // Clear the error message
              isLoading = true;
            });
            _handleTabSelection(); // Retry the operation
          },
        ),
      );
    }
    if (isLoading) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ));
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(15), // here the desired height
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swiping between pages
          children: [
            HomePage(
              tabController: tabController,
            ),
            JobPost(),
            // Applicaions(text: 'Bookmarks'),
            JobApplicants(),
            InstitutionSettings(),
            // ORTest()
          ],
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 1.2, color: Color.fromARGB(50, 36, 107, 253)),
            ),
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
}

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.tabController,
  });
  final tabController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool error = false;
  List<dynamic> pros = [];
  final TextEditingController _searchController = TextEditingController();
  DateTime? currentBackPressTime;

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

  void fetchPros() async {
    try {
      final data = await getAllProfessionals();
      if (data != null) {
        setState(() {
          isLoading = false;
          pros = data;
          error = false;
        });
      }
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  void searchPros(name) async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await searchProfessionals(name);
      if (data != null) {
        setState(() {
          isLoading = false;
          error = false;
          pros = data;
        });
      }
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPros();
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
            )),
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
                    fetchPros();
                  },
                  label: 'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find The Ideal Employee',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue.shade900,
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(144, 44, 44, 44),
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
                              searchPros(searchTerm);
                            },
                          ),
                          hintText: 'Search a Professional',
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
                          searchPros(searchTerm);
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
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10, right: 5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: pros?.length,
                itemBuilder: (context, index) {
                  final pro = pros?[index];
                  print(pro);
                  return GestureDetector(
                    child: HealthProfessional(
                      name: "${pro['firstName']} ${pro['lastName']}",
                      skills: "${pro['Skills']}",
                      profession: "${pro['profession']}",
                      displayIcon: false,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProffesionalDetails(
                            pro: pro,
                          ),
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      );
    }
  }
}

class HealthProfessional extends StatefulWidget {
  HealthProfessional({
    super.key,
    this.displayedIcon = Icons.bookmark_border,
    this.iconColor = Colors.grey,
    this.isBookmark = false,
    this.name = "",
    this.displayIcon = true,
    this.skills = "",
    this.profession = "",
  });
  final displayedIcon;
  final iconColor;
  final isBookmark;
  final skills;
  final profession;
  final name;
  bool displayIcon;

  @override
  State<HealthProfessional> createState() => _HealthProfessionalState();
}

class _HealthProfessionalState extends State<HealthProfessional> {
  late Color iconColor;
  late IconData displayedIcon;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    iconColor = widget.iconColor;
    displayedIcon = widget.displayedIcon; // Ensure it's an IconData
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 5, bottom: 5),
        height: 170,
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
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset('assets/images/image2vector.svg'),
                    ),
                    // Icon(Icons.bookmark_border)
                    widget.displayIcon
                        ? InkWell(
                            onTap: () {
                              selected = !selected;
                              setState(() {});
                            },
                            child: Icon(
                              displayedIcon,
                              color: selected && !widget.isBookmark
                                  ? const Color.fromRGBO(17, 160, 0, 1)
                                  : iconColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  widget.profession,
                  style: TextStyle(color: Colors.grey, fontSize: 11.5),
                ),
                Text(
                  "${widget.skills.split(', ').join(',\n')}",
                  style: TextStyle(color: Colors.grey, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ),
      );
}

class Applicaions extends StatelessWidget {
  const Applicaions({super.key, required this.text});
  final text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Center(
        child: Text("You currently have no $text"),
      ),
    );
  }
}
