import 'package:flutter/material.dart';
import 'package:health_app/Pages/documentsPage.dart';
import 'package:health_app/Pages/paymentPage.dart';
import 'package:health_app/models/ExperiencePageData.dart';
import 'package:health_app/util/components.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = ExperienceData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leadingWidth: 30,
        title: const Text(
          'Experience & Skills',
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
                    child: SingleSelectDropDownBtn(
                      items: const [
                        'Less Than High School',
                        'High School',
                        'Diploma',
                        "Bachelor's Degree",
                        "Master's Degree",
                        'Doctoral or Professional Degree'
                      ],
                      label: 'Education Level',
                      update: (value) {
                        data.educationLevel = value;
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
                        data.workExperienceYears = value;
                      },
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: InputBox(
                      inputLabel: 'Organizational/Employer Name',
                      placeHolder: 'Employer Name',
                      update: (value) {
                        data.employerName = value;
                      },
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: InputBox(
                      inputLabel: 'Occupation or Position held',
                      placeHolder: 'Enter your position at this organization',
                      update: (value) {
                        data.positionHeld = value;
                      },
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: DatePicker(
                      placeHolder: 'Enter starting date with this company',
                      inputLabel: 'Starting Date at the company',
                      update: (value) {
                        data.startingDateWithCompany = value;
                      },
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: DatePicker(
                      placeHolder: 'Ending Date at the company',
                      inputLabel: 'Ending Date at the company',
                      update: (value) {
                        data.endingDateWithCompany = value;
                      },
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: InputBox(
                      inputLabel: 'Main Activities and Responsibilities',
                      placeHolder:
                          'Write a summary of your Activities and Responsibilities...',
                      update: (value) {
                        data.mainResponsibilities = value;
                      },
                      textArea: true,
                    ),
                  ),
                ],
              ))),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: CustomButton(
              onPressed: () async {
                if (data.checkExperienceData()) {
                  showSnackbar(context);
                  return;
                }
                final response = await data.sendData();
                if (response != null) {
                  // await Navigator.pushNamed(context, 'documents-page');
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Documents(),
                    ),
                  );
                } else {
                  showSnackbar(context,
                      text: 'Failed to save info, Please try again.');
                }
              },
              label: 'Proceed',
            ),
          ),
        ],
      ),
    );
  }
}
