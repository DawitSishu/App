import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/models/OrganizationInfoPage1Data.dart';
import 'package:health_app/util/components.dart';

class InstitutionSettings extends StatefulWidget {
  const InstitutionSettings({Key? key}) : super(key: key);

  @override
  State<InstitutionSettings> createState() => _InstitutionSettingsState();
}

class _InstitutionSettingsState extends State<InstitutionSettings> {
  bool editing = false;
  OrganizationData data = new OrganizationData();
  Map<String, dynamic> profile = {};
  Map<String, dynamic> editedData = {};
  bool isLoading = true;
  bool error = false;

  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController organizationTypeController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController contactPersonNameController =
      TextEditingController();
  final TextEditingController contactPersonPositionController =
      TextEditingController();
  final TextEditingController contactPersonPhoneNumberController =
      TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController subCityController = TextEditingController();
  final TextEditingController weredaController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();

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
    if (organizationNameController.text.isEmpty ||
        organizationTypeController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        contactPersonNameController.text.isEmpty ||
        contactPersonPositionController.text.isEmpty ||
        contactPersonPhoneNumberController.text.isEmpty ||
        emailAddressController.text.isEmpty ||
        cityController.text.isEmpty ||
        subCityController.text.isEmpty ||
        weredaController.text.isEmpty ||
        houseNumberController.text.isEmpty) {
      organizationNameController.text = profile['OrganizationName'] ?? '';
      organizationTypeController.text = profile['OrganizationType'] ?? '';
      phoneNumberController.text = profile['PhoneNumber'] ?? '';
      contactPersonNameController.text = profile['ContactPerson_Name'] ?? '';
      contactPersonPositionController.text =
          profile['ContactPerson_Position'] ?? '';
      contactPersonPhoneNumberController.text =
          profile['ContactPerson_Number'] ?? '';
      emailAddressController.text = profile['EmailAddress'] ?? '';
      cityController.text = profile['city'] ?? '';
      subCityController.text = profile['subCity'] ?? '';
      weredaController.text = profile['wereda'] ?? '';
      houseNumberController.text = profile['houseNo'] ?? '';
      showSnackbar(context, text: 'Please fill in all fields ad try again');
      return;
    }
    setState(() {
      isLoading = true;
    });
    editedData['name'] = organizationNameController.text;
    editedData['type'] = organizationTypeController.text;
    editedData['phoneNumber'] = phoneNumberController.text;
    editedData['email'] = emailAddressController.text;
    editedData['city'] = cityController.text;
    editedData['subCity'] = subCityController.text;
    editedData['wereda'] = weredaController.text;
    editedData['houseNo'] = houseNumberController.text;
    editedData['tinNo'] = profile['tinNo'];
    editedData['contactPersonName'] = contactPersonNameController.text;
    editedData['contactPersonPosition'] = contactPersonPositionController.text;
    editedData['contactPersonNumber'] = contactPersonPhoneNumberController.text;
    final response = await UpdateOrgProfile(editedData);
    if (response != null) {
      successSnackbar(context, text: response["message"]);

      setState(() {
        isLoading = false;
      });
      fetchData();
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
      final lists = await InstitutionDetail();
      if (lists != null) {
        profile = lists;

        organizationNameController.text = profile['OrganizationName'] ?? '';
        organizationTypeController.text = profile['OrganizationType'] ?? '';
        phoneNumberController.text = profile['PhoneNumber'] ?? '';
        contactPersonNameController.text = profile['ContactPerson_Name'] ?? '';
        contactPersonPositionController.text =
            profile['ContactPerson_Position'] ?? '';
        contactPersonPhoneNumberController.text =
            profile['ContactPerson_Number'] ?? '';
        emailAddressController.text = profile['EmailAddress'] ?? '';
        cityController.text = profile['city'] ?? '';
        subCityController.text = profile['subCity'] ?? '';
        weredaController.text = profile['wereda'] ?? '';
        houseNumberController.text = profile['houseNo'] ?? '';

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
        isLoading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    final inputItems = <Widget>[
      SizedBox(
        height: 10,
      ),
      InputBox(
          inputLabel: 'Organisation Name',
          placeHolder: 'Organisation Name',
          customController: organizationNameController,
          update: (value) {
            data.organizationName = value;
          }),
      SingleSelectDropDownBtn(
        initialValue: organizationTypeController.text,
        items: const [
          'Hospital',
          'Medium clinic',
          'Sub-specialty clinic',
          'Pharmacy/importer',
          'Pharmacy/Whole seller',
          'Laboratory diagnostic center',
          'Imaging diagnostic center',
          'Other health service provider'
        ],
        update: (value) {
          organizationTypeController.text = value;
        },
        label: 'Type of Organization',
      ),
      InputBox(
          initialValue: removePhonePrefix(phoneNumberController.text),
          inputLabel: 'Phone Number',
          isPhone: true,
          isCountry: true,
          placeHolder: '9*********',
          update: (value) {
            phoneNumberController.text = value;
          }),
      InputBox(
          inputLabel: 'Contact Person Name',
          placeHolder: 'Contact Person Name',
          customController: contactPersonNameController,
          update: (value) {
            data.contactPersonName = value;
          }),
      InputBox(
          inputLabel: 'Contact Person Position',
          placeHolder: 'Contact Person Position',
          customController: contactPersonPositionController,
          update: (value) {
            data.contactPersonPosition = value;
          }),
      InputBox(
          initialValue:
              removePhonePrefix(contactPersonPhoneNumberController.text),
          isPhone: true,
          isCountry: true,
          inputLabel: 'Contact Person Number',
          placeHolder: '9*********',
          update: (value) {
            contactPersonPhoneNumberController.text = value;
          }),
      InputBox(
          inputLabel: 'Email',
          placeHolder: 'someone@gmail.com',
          customController: emailAddressController,
          update: (value) {
            data.emailAddress = value;
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
          inputLabel: 'House Number',
          placeHolder: 'House Number',
          customController: houseNumberController,
          update: (value) {
            data.houseNumber = value;
          }),
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
            'Organization Settings',
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
                        // Implement saveData for organization
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
        body: editing
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
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
                                profile['OrganizationName'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile['OrganizationType'],
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReusableProfileField(
                    icon: Icons.email,
                    label: "Email Address",
                    value: profile['EmailAddress'],
                  ),
                  ReusableProfileField(
                    icon: Icons.phone,
                    label: "Phone Number",
                    value: profile['PhoneNumber'],
                  ),
                  ReusableProfileField(
                    icon: Icons.location_city,
                    label: "City",
                    value: profile['city'],
                  ),
                  ReusableProfileField(
                    icon: Icons.location_city,
                    label: "Sub City",
                    value: profile['subCity'],
                  ),
                  ReusableProfileField(
                    icon: Icons.location_on,
                    label: "Wereda",
                    value: profile['wereda'],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: const Text(
                      "Additional Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ReusableProfileField(
                    icon: Icons.home,
                    label: "House No",
                    value: profile['houseNo'],
                  ),
                  ReusableProfileField(
                    icon: Icons.confirmation_number,
                    label: "TIN No",
                    value: profile['tinNo'],
                  ),
                  ReusableProfileField(
                    icon: Icons.person,
                    label: "Contact Person Name",
                    value: profile['ContactPerson_Name'],
                  ),
                  ReusableProfileField(
                    icon: Icons.work,
                    label: "Contact Person Position",
                    value: profile['ContactPerson_Position'],
                  ),
                  ReusableProfileField(
                    icon: Icons.phone,
                    label: "Contact Person Number",
                    value: profile['ContactPerson_Number'],
                  ),
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
      );
    }
  }
}

class ReusableProfileField extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const ReusableProfileField({
    Key? key,
    this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Icon(icon, color: Colors.white, size: 25),
            ),
          if (icon != null) const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
