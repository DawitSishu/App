import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/models/PersonalInfoPageData.dart';
import 'package:health_app/util/components.dart';

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({Key? key}) : super(key: key);

  @override
  State<PersonalSettings> createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  bool editing = false;
  PersonalData data = new PersonalData();
  Map<String, dynamic> profile = {};
  Map<String, dynamic> editedData = {};
  bool isLoading = true;
  bool error = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController subCityController = TextEditingController();
  final TextEditingController weredaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  String removePhonePrefix(String phoneNumber) {
    if (phoneNumber.startsWith('+251')) {
      return phoneNumber.substring(4);
    } else if (phoneNumber.startsWith('0')) {
      return phoneNumber.substring(1);
    } else if (phoneNumber.startsWith('025')) {
      return phoneNumber.substring(3);
    } else {
      return phoneNumber;
    }
  }

  void saveData() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        cityController.text.isEmpty ||
        subCityController.text.isEmpty ||
        weredaController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      firstNameController.text = profile['firstName'] ?? '';
      lastNameController.text = profile['lastName'] ?? '';
      cityController.text = profile['city'] ?? '';
      subCityController.text = profile['subCity'] ?? '';
      weredaController.text = profile['wereda'] ?? '';
      emailController.text = profile['email'] ?? '';
      phoneNumberController.text = profile['phoneNumber'] ?? '';
      skillsController.text = profile['Skills'] ?? '';
      showSnackbar(context, text: 'Please fill in all fields ad try again');
      return;
    }
    setState(() {
      isLoading = true;
    });
    editedData['firstName'] = firstNameController.text;
    editedData['Age'] = profile['Age'];
    editedData['Gender'] = profile['Gender'];
    editedData['profession'] = profile['profession'];
    editedData['languages'] = profile['languages'];
    editedData['Skills'] = skillsController.text;
    editedData['lastName'] = lastNameController.text;
    editedData['city'] = cityController.text;
    editedData['subCity'] = subCityController.text;
    editedData['wereda'] = weredaController.text;
    editedData['email'] = emailController.text;
    editedData['phoneNumber'] = phoneNumberController.text;

    final response = await UpdateProfessionalProfile(editedData);
    if (response != null) {
      successSnackbar(context, text: response["message"]);
      setState(() {
        profile = editedData;
        isLoading = false;
      });
    } else {
      showSnackbar(context, text: 'Failed Update Profile, Please try Again.');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final lists = await ProfessionalPersonalDetail();
      if (lists != null && lists.length > 0) {
        profile = lists;

        firstNameController.text = profile['firstName'] ?? '';
        lastNameController.text = profile['lastName'] ?? '';
        cityController.text = profile['city'] ?? '';
        subCityController.text = profile['subCity'] ?? '';
        weredaController.text = profile['wereda'] ?? '';
        emailController.text = profile['email'] ?? '';
        phoneNumberController.text = profile['phoneNumber'] ?? '';
        skillsController.text = profile['Skills'] ?? '';
        setState(() {
          isLoading = false;
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
        isLoading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputItems = <Widget>[
      InputBox(
          inputLabel: 'First Name',
          placeHolder: 'First Name',
          customController: firstNameController,
          update: (value) {
            data.firstName = value;
          }),
      InputBox(
          inputLabel: 'Last Name',
          placeHolder: 'Last Name',
          customController: lastNameController,
          update: (value) {
            data.lastName = value;
          }),
      InputBox(
          initialValue: removePhonePrefix(phoneNumberController.text),
          inputLabel: 'Phone Number',
          placeHolder: '9*********',
          isPhone: true,
          isCountry: true,
          update: (value) {
            phoneNumberController.text = value;
          }),
      InputBox(
          inputLabel: 'Email',
          placeHolder: 'someone@gmail.com',
          customController: emailController,
          update: (value) {
            data.email = value;
          }),
      SingleSelectDropDownBtn(
        initialValue: cityController.text,
        items: const [
          'Addis Ababa',
          'Adama',
        ],
        label: 'City',
        update: (value) {
          cityController.text = value;
        },
      ),
      SingleSelectDropDownBtn(
        initialValue: subCityController.text,
        items: const [
          'Arada',
          'Bole',
          'Gullele',
          'Lideta',
          'Yeka',
        ],
        label: 'Sub-City',
        update: (value) {
          subCityController.text = value;
        },
      ),
      InputBox(
          inputLabel: 'Wereda',
          placeHolder: 'Wereda',
          customController: weredaController,
          update: (value) {
            data.wereda = value;
          }),
      InputBox(
        customController: skillsController,
        inputLabel: 'Skills',
        placeHolder: 'Write the different kinds of skills you possess',
        update: (value) {
          data.skills = value;
        },
        textArea: true,
      ),
    ];
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: editing
              ? Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: ListView(
                    shrinkWrap: true,
                    children: inputItems
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: item,
                            ))
                        .toList(),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 4,
                          child: SvgPicture.asset(
                            'assets/images/image2vector.svg',
                            height: 70,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profile['firstName']} ${profile['lastName']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Health Professional",
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ReusableProfileField(
                        icon: Icons.phone,
                        label: "Phone Number",
                        value: "${profile['phoneNumber']}"),
                    ReusableProfileField(
                        icon: Icons.email,
                        label: "Email",
                        value: "${profile['email']}"),
                    ReusableProfileField(
                        icon: Icons.location_city,
                        label: "City",
                        value: "${profile['city']}"),
                    ReusableProfileField(
                        icon: Icons.location_city,
                        label: "Subcity",
                        value: "${profile['subCity']}"),
                    ReusableProfileField(
                        icon: Icons.location_on,
                        label: "Wereda",
                        value: "${profile['wereda']}"),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      "Additional Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ReusableProfileField(
                        label: "profession", value: "${profile['profession']}"),
                    ReusableProfileField(
                        label: "languages", value: "${profile['languages']}"),
                    ReusableProfileField(
                        label: "Skills", value: "${profile['Skills']}"),
                    const SizedBox(height: 10),
                    InkWell(
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
                  ],
                ),
        ),
      );
    }
  }
}

class ReusableProfileField extends StatefulWidget {
  final IconData? icon;
  final String? label;
  final String value;

  const ReusableProfileField({
    Key? key,
    this.icon,
    this.label,
    required this.value,
  }) : super(key: key);

  @override
  State<ReusableProfileField> createState() => _ReusableProfileFieldState();
}

class _ReusableProfileFieldState extends State<ReusableProfileField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.icon != null)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Icon(widget.icon, color: Colors.white, size: 25),
            ),
          if (widget.icon != null) const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (widget.label != null) const SizedBox(height: 2),
              Text(
                widget.value,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
