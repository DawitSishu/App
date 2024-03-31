import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/util/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/general-controller.dart';
import '../models/OrganizationInfoPage1Data.dart';

class tst extends StatefulWidget {
  const tst({super.key});

  @override
  State<tst> createState() => _tstState();
}

class _tstState extends State<tst> {
  bool editing = false;
  OrganizationData data = new OrganizationData();
  Map<String, dynamic> profile = {};
  Map<String, dynamic> editedData = {};
  bool error = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void saveData() async {
    editedData['name'] = data.organizationName;
    editedData['contactPersonName'] = data.contactPersonName;
    editedData['contactPersonPosition'] = data.contactPersonPosition;
    editedData['contactPersonNumber'] = data.contactPersonPhoneNumber;
    editedData['email'] = data.emailAddress;
    editedData['phoneNumber'] = data.phoneNumber;
    editedData['type'] = profile['OrganizationType'];
    editedData['city'] = profile['city'];
    editedData['subCity'] = profile['subCity'];
    editedData['wereda'] = profile['wereda'];
    editedData['houseNo'] = profile['houseNo'];
    editedData['tinNo'] = profile['tinNo'];
    setState(() {
      isLoading = true;
    });
    final response = await UpdateOrgProfile(editedData);
    if (response != null) {
      successSnackbar(context, text: response["message"]);
      fetchData();
    } else {
      showSnackbar(context, text: 'Failed Update Profile, Please try Again.');
      setState(() {
        error = true;
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final lists = await InstitutionDetail();
      if (lists != null) {
        profile = lists;
        setState(() {
          isLoading = false;
          error = false;
        });
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
    final width = MediaQuery.of(context).size.width - 40;
    final infoItems = <Widget>[
      Container(
        constraints: BoxConstraints(
          maxWidth: width / 2 - 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Headlines(
              text: 'Contact Person Name',
            ),
            if (editing)
              InputBox(
                inputLabel: 'Contact Person Name',
                placeHolder: 'Contact Person Name',
                update: (value) {
                  data.contactPersonName = value;
                },
              )
            else
              Text(
                '${profile['ContactPerson_Name']}',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
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
            const Headlines(text: 'Contact Person Position', end: true),
            if (editing)
              InputBox(
                inputLabel: 'Contact Person Position',
                placeHolder: 'Contact Person Position',
                update: (value) {
                  data.contactPersonPosition = value;
                },
              )
            else
              Text(
                '${profile['ContactPerson_Position']}',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
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
            const Headlines(
              text: 'Contact Person Phone',
            ),
            if (editing)
              InputBox(
                inputLabel: 'Contact Person Phone',
                placeHolder: 'Contact Person Phone',
                update: (value) {
                  data.contactPersonPhoneNumber = value;
                },
              )
            else
              Text(
                '${profile['ContactPerson_Number']}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
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
            const Headlines(text: 'Email address', end: true),
            if (editing)
              InputBox(
                inputLabel: 'Email',
                placeHolder: 'someone@gmail.com',
                update: (value) {
                  data.emailAddress = value;
                },
              )
            else
              Text(
                '${profile['EmailAddress']}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
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
            const Headlines(
              text: 'Phone Number',
            ),
            if (editing)
              InputBox(
                inputLabel: 'Phone Number',
                placeHolder: '+251 *********',
                update: (value) {
                  data.phoneNumber = value;
                },
              )
            else
              Text(
                '${profile['PhoneNumber']}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    ];

    final inputItems = <Widget>[
      InputBox(
        inputLabel: 'Contact Person Name',
        placeHolder: 'Contact Person Name',
        update: (value) {
          data.contactPersonName = value;
        },
      ),
      InputBox(
        inputLabel: 'Contact Person Position',
        placeHolder: 'Contact Person Position',
        update: (value) {
          data.contactPersonPosition = value;
        },
      ),
      InputBox(
        inputLabel: 'Contact Person Phone',
        placeHolder: 'Contact Person Phone',
        update: (value) {
          data.contactPersonPhoneNumber = value;
        },
      ),
      InputBox(
        inputLabel: 'Email address',
        placeHolder: 'someone@gmail.com',
        update: (value) {
          data.emailAddress = value;
        },
      ),
      InputBox(
        inputLabel: 'Phone Number',
        placeHolder: '+251 9********',
        update: (value) {
          data.phoneNumber = value;
        },
      )
    ];
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
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.settings_outlined,
            size: 25,
            color: Colors.blue.shade800,
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.blue.shade900,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: editing
                  ? InkWell(
                      onTap: () {
                        saveData();
                        setState(() {
                          editing = !editing;
                        });
                      },
                      child: const Icon(
                        Icons.check,
                        color: Color.fromRGBO(43, 186, 31, 1),
                        size: 28,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        data.printOrganizationData();
                        setState(() {
                          editing = !editing;
                        });
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 36, 107, 253),
                        size: 28,
                      ),
                    ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                      height: 10,
                    ),
                    if (editing)
                      InputBox(
                        inputLabel: 'Organization Name',
                        placeHolder: 'Organization Name',
                        update: (value) {
                          data.organizationName = value;
                        },
                      )
                    else
                      Text(
                        '${profile['OrganizationName']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.count(
                  childAspectRatio: editing ? 3 : 2,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: editing ? 1 : 2,
                  children: editing ? inputItems : infoItems,
                ),
              ),
            ),
            const SizedBox(
              height: 55,
            ),
          ],
          // ]),
        ),
        floatingActionButton: editing
            ? null
            : InkWell(
                onTap: () async {
                  bool confirm = await showConfirmationDialog(
                    context,
                    'Confirm Log Out',
                    'Are you sure you want to Log Out?',
                  );
                  if (confirm) {
                    await logOut();
                    await Navigator.popAndPushNamed(
                      context,
                      '/',
                    );
                  } else {
                    return;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      color: const Color.fromARGB(255, 36, 107, 253),
                      padding: const EdgeInsets.all(0),
                      iconSize: 30,
                      alignment: Alignment.centerRight,
                      onPressed: () async {
                        bool confirm = await showConfirmationDialog(
                          context,
                          'Confirm Log Out',
                          'Are you sure you want to Log Out?',
                        );
                        if (confirm) {
                          await logOut();
                          await Navigator.popAndPushNamed(
                            context,
                            '/',
                          );
                        } else {
                          return;
                        }
                      },
                      icon: const Icon(Icons.logout),
                    ),
                    const Text('Log out'),
                  ],
                ),
              ),
      );
    }
  }
}
