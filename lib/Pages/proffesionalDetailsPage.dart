import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_app/util/components.dart';

import '../models/PersonalInfoPageData.dart';

class ProffesionalDetails extends StatefulWidget {
  final pro;
  ProffesionalDetails({super.key, this.pro = ''});

  @override
  State<ProffesionalDetails> createState() => _ProffesionalDetailsState();
}

class _ProffesionalDetailsState extends State<ProffesionalDetails> {
  bool editing = false;
  PersonalData data = new PersonalData();

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
              text: 'Profession',
            ),
            Text(
              widget.pro["profession"],
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
            const Headlines(text: 'Education Level', end: true),
            Text(
              widget.pro["EducationLevel"] ?? 'none',
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
              text: 'City',
            ),
            Text(
              widget.pro["city"],
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
            const Headlines(text: 'Experience', end: true),
            Text(
              '${widget.pro["WorkExperienceYear"] ?? 0} Years',
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
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.person,
          size: 25,
          color: Colors.blue.shade800,
        ),
        title: Text(
          'Health Proffesional Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.blue.shade900,
          ),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    "${widget.pro['firstName']} ${widget.pro['lastName']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                children: infoItems,
              ),
            ),
          ),
          const SizedBox(
            height: 55,
          ),
        ],
        // ]),
      ),
    );
  }
}
