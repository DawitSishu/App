import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Pages/HealthInstitutionHomePage.dart';
import 'package:health_app/Pages/proffesionalDetailsPage.dart';

class JobApplicantProfessionals extends StatefulWidget {
  const JobApplicantProfessionals({super.key, required this.pros});

  final pros;

  @override
  State<JobApplicantProfessionals> createState() =>
      _JobApplicantProfessionalsState();
}

class _JobApplicantProfessionalsState extends State<JobApplicantProfessionals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.blue.shade900,
          ),
          title: Text(
            'Applicant Professionals',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.blue.shade900,
            ),
          ),
        ),
        body: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 10, right: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: widget.pros?.length,
            itemBuilder: (context, index) {
              final pro = widget.pros?[index];
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
            }));
  }
}
