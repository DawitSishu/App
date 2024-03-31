import 'package:flutter/material.dart';
import 'package:health_app/Services/general-controller.dart';
import 'package:health_app/util/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  String type;

  PaymentPage({super.key, this.type = ''});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isCBE = true;
  String transactionID = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final cardWidth = (MediaQuery.of(context).size.width - 40) / 2 - 10;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: height * 0.15,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                    constraints: const BoxConstraints(
                      minHeight: 100,
                    ),
                    child: Center(
                      child: Image.asset('assets/images/health app logo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const WidgetSpace(
                    space: 18,
                    child: Text(
                      'Activate Your Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const WidgetSpace(
                    space: 45,
                    child: Text(
                      'Choose which method of payment you want to continue with, your account won\'t be activated until you make the neccessary payments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.3,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  WidgetSpace(
                    space: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 2,
                                  color: isCBE
                                      ? const Color.fromRGBO(44, 113, 254, 1)
                                      : const Color.fromRGBO(239, 239, 239, 1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              if (!isCBE) {
                                setState(() {
                                  isCBE = true;
                                });
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Column(
                                children: [
                                  Image.asset('assets/images/CBE.png'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'CBE Mobile\nBanking',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      height: 1.1,
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 2,
                                  color: !isCBE
                                      ? const Color.fromRGBO(44, 113, 254, 1)
                                      : const Color.fromRGBO(239, 239, 239, 1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              if (isCBE) {
                                setState(() {
                                  isCBE = false;
                                });
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Column(children: [
                                Image.asset(
                                  'assets/images/TBIRR.png',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Telebirr',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WidgetSpace(
                    space: 20,
                    child: InputBox(
                      inputLabel: 'Transaction ID',
                      placeHolder: 'Transaction ID',
                      update: (value) {
                        transactionID = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        onPressed: () async {
                          try {
                            final prefs = await SharedPreferences.getInstance();
                            widget.type = prefs.getString('userType')!;

                            final result =
                                await addTransactionID(transactionID);

                            if (result != null) {
                              successSnackbar(context, text: result["message"]);
                            } else {
                              showSnackbar(context,
                                  text: "Error: Please, Try Again.");
                            }

                            if (widget.type == 'professional') {
                              Navigator.popAndPushNamed(
                                context,
                                // 'health-professional-page',
                                'pending-payment-page',
                              );
                            } else if (widget.type == 'organization') {
                              Navigator.popAndPushNamed(
                                context,
                                // 'health-institution-page',
                                'pending-payment-page',
                              );
                            } else {
                              showSnackbar(context,
                                  text: "Error: Please, Try Again.");
                            }
                          } catch (e) {
                            // TODO
                            showSnackbar(context,
                                text: "Error: Please, Try Again.");
                          }
                        },
                        label: 'Activate',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
