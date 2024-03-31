import 'package:flutter/material.dart';
import 'package:health_app/models/PersonalInfoPageData.dart';
import 'package:health_app/util/components.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  void notifyListeners() {
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final data = PersonalData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leadingWidth: 30,
        title: const Text(
          'Personal Information',
          style: TextStyle(
            overflow: TextOverflow.fade,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'First Name',
                  placeHolder: 'First name',
                  update: (value) {
                    data.firstName = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Last Name',
                  placeHolder: 'Last Name',
                  update: (value) {
                    data.lastName = value;
                  },
                ),
              ),
              WidgetSpace(
                  space: 20,
                  child: DatePicker(
                    placeHolder: 'Birth Date',
                    inputLabel: 'Birth Date',
                    update: (value) {
                      DateTime currentDate = DateTime.now();
                      num age = currentDate.year - value.year;
                      if (currentDate.month < value.month ||
                          (currentDate.month == value.month &&
                              currentDate.day < value.day)) {
                        age--;
                      }
                      data.age = "$age";
                      // data.age
                    },
                  )),
              WidgetSpace(
                space: 20,
                child: SingleSelectDropDownBtn(
                  items: const ['Male', 'Female'],
                  label: 'Select Gender',
                  update: (value) {
                    data.gender = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: SingleSelectDropDownBtn(
                  items: const [
                    'Addis Ababa',
                    'Adama',
                  ],
                  label: 'City',
                  update: (value) {
                    data.city = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: SingleSelectDropDownBtn(
                  items: const [
                    'Arada',
                    'Bole',
                    'Gullele',
                    'Lideta',
                    'Yeka',
                  ],
                  label: 'Sub-City',
                  update: (value) {
                    data.subCity = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Wereda',
                  placeHolder: 'wereda',
                  update: (value) {
                    data.wereda = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Email address',
                  placeHolder: 'example@mail.com',
                  update: (value) {
                    data.email = value;
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Profession',
                  placeHolder: 'Write a summary on your profession...',
                  update: (value) {
                    data.profession = value;
                  },
                  textArea: true,
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Skills',
                  placeHolder:
                      'Write the different kinds of skills you possess',
                  update: (value) {
                    data.skills = value;
                  },
                  textArea: true,
                ),
              ),
              WidgetSpace(
                  space: 20,
                  child: DropDownBtn(
                    items: const ['Amharic', 'English', 'Oromiffa'],
                    label: 'Languages',
                    update: (value) {
                      data.languages = value;
                    },
                  )),
              CustomButton(
                onPressed: () async {
                  if (int.tryParse(data.age) != null &&
                      int.parse(data.age) <= 18) {
                    showSnackbar(context,
                        text: "You must be at least 18 years old!!");
                    return;
                  }
                  if (!isEmailValid(data.email)) {
                    showSnackbar(context,
                        text: "Please Provide a Valid Email!!");
                    return;
                  }
                  if (data.checkPersonalData()) {
                    showSnackbar(context, text: "Please include all fields");
                    return;
                  }

                  final response = await data.sendData();
                  if (response != null) {
                    Navigator.pushNamed(context, 'experience-page');
                  } else {
                    showSnackbar(context,
                        text: 'Failed to post data, Please try again!');
                  }
                },
                label: 'Proceed',
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }
}
