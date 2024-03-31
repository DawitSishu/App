import 'package:flutter/material.dart';
import 'package:health_app/Pages/paymentPage.dart';
import 'package:health_app/models/OrganizationInfoPage1Data.dart';
import 'package:health_app/util/components.dart';
import 'package:flutter/scheduler.dart';

class OrganizationInfo extends StatefulWidget {
  const OrganizationInfo({super.key});

  @override
  State<OrganizationInfo> createState() => _OrganizationInfoState();
}

class _OrganizationInfoState extends State<OrganizationInfo> {
  OrganizationData data = OrganizationData();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Organization Information',
            style: TextStyle(
              fontSize: 20,
              overflow: TextOverflow.fade,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leadingWidth: 30,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InputBox(
                            inputLabel: 'Organization Name',
                            placeHolder: 'Organization Name',
                            update: (value) {
                              data.organizationName = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleSelectDropDownBtn(
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
                              data.organizationType = value;
                            },
                            label: 'Type of Organization',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Email Address',
                            placeHolder: 'example@mail.com',
                            update: (value) {
                              data.emailAddress = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Phone Number (Land Line)',
                            placeHolder: '911*****',
                            update: (value) {
                              data.phoneNumber = value;
                            },
                            isPhone: true,
                            isCountry: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleSelectDropDownBtn(
                            items: const [
                              'Addis Ababa',
                              'Adama',
                            ],
                            label: 'City',
                            update: (value) {
                              data.city = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleSelectDropDownBtn(
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
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Wereda',
                            placeHolder: 'wereda',
                            update: (value) {
                              data.wereda = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'House Number',
                            placeHolder: 'house number',
                            update: (value) {
                              data.houseNumber = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Tin Number',
                            placeHolder: 'Tin number',
                            update: (value) {
                              data.tinNumber = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Contact Person Name',
                            placeHolder: 'contact person name',
                            update: (value) {
                              data.contactPersonName = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Contact Person Position',
                            placeHolder: 'Position',
                            update: (value) {
                              data.contactPersonPosition = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InputBox(
                            inputLabel: 'Contact Person Phone Number',
                            placeHolder: '911*****',
                            isPhone: true,
                            isCountry: true,
                            update: (value) {
                              data.contactPersonPhoneNumber = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: CustomButton(
                      onPressed: () async {
                        // data.printOrganizationData();
                        if (data.checkOrganizationData()) {
                          showSnackbar(context);
                          return;
                        }
                        final response = await data.sendData();
                        if (response != null) {
                          // Navigator.pushNamed(
                          //     context, 'organization-page-info2');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(type: 'organization'),
                            ),
                          );
                        } else {
                          showSnackbar(context,
                              text: 'Failed to save, Please try again');
                        }
                      },
                      label: 'Proceed',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
