import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/models/VerificationPageData.dart';

import '../util/components.dart';
import 'optionsPage.dart';
import 'registerPage.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    super.key,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController fieldOne = TextEditingController();
  final TextEditingController fieldTwo = TextEditingController();
  final TextEditingController fieldThree = TextEditingController();
  final TextEditingController fieldFour = TextEditingController();
  final TextEditingController fieldFive = TextEditingController();
  final TextEditingController fieldSix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = VerificationData();
    final height = MediaQuery.of(context).size.height;

    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {},
          color: Colors.black,
        ),
        title: const Text(
          'OTP code verification',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                150,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Code has been sent to ${Register.phoneNumber}',
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OtpInput(fieldOne, true), // auto focus
                  OtpInput(fieldTwo, false),
                  OtpInput(fieldThree, false),
                  OtpInput(fieldFour, false),
                  OtpInput(fieldFive, false),
                  OtpInput(fieldSix, false)
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CountDown(),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      height: 50,
                      child: CustomButton(
                        onPressed: () async {
                          data.Pin =
                              '${fieldOne.text}${fieldTwo.text}${fieldThree.text}${fieldFour.text}${fieldFive.text}${fieldSix.text}';
                          final isVerified = await data.verifyAndSignIn();
                          if (isVerified['success']) {
                            if (OptionsPage.employee) {
                              Navigator.popAndPushNamed(
                                  context, 'personal-info-page');
                            } else {
                              Navigator.popAndPushNamed(
                                  context, 'organization-page-info');
                            }
                          } else {
                            String error = isVerified['error']
                                .toString()
                                .replaceAll(RegExp(r'\[.*\]'), '');
                            showSnackbar(context, text: error);
                          }
                        },
                        label: 'Verify',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);
  final TextEditingController controller;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        height: 41,
        width: 40,
        child: Center(
          child: TextField(
            cursorHeight: 12,
            autofocus: autoFocus,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: controller,
            maxLength: 1,
            cursorColor: Theme.of(context).primaryColor,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
      );
}

class CountDown extends StatefulWidget {
  const CountDown({super.key});

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  int timeLeft = 60;
  @override
  void initState() {
    super.initState();
    Counter();
  }

  void Counter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        //resend Code
      }
    });
  }

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: 'OTP will be sent shortly',
          style: const TextStyle(color: Colors.grey),
          // children: [
          //   TextSpan(
          //     text: timeLeft.toString(),
          //     style: const TextStyle(
          //       color: Colors.green,
          //     ),
          //   ),
          // ],
        ),
      );
}
