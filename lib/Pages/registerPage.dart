import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/models/RegisterPageData.dart';
import 'package:health_app/util/components.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static var verificationId;
  static var phoneNumber;
  static var password;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final data = RegisterData();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.25,
              constraints: const BoxConstraints(
                minHeight: 190,
              ),
              child: Center(
                child: Image.asset('assets/images/health app logo.png'),
              ),
            ),
            Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(200, 200, 200, 0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    minHeight: height * 0.65,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const WidgetSpace(
                        space: 5,
                        child: Text(
                          'Welcome !',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      WidgetSpace(
                        space: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Sign up to',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              'Health App',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      WidgetSpace(
                        space: 10,
                        child: InputBox(
                          inputLabel: 'Phone number',
                          placeHolder: '9********',
                          update: (value) {
                            data.phoneNumber = value;
                          },
                          isPhone: true,
                          isCountry: true,
                        ),
                      ),
                      WidgetSpace(
                        space: 10,
                        child: InputBox(
                          inputLabel: 'Password',
                          placeHolder: '************',
                          update: (value) {
                            data.password = value;
                          },
                          isPassword: true,
                        ),
                      ),
                      WidgetSpace(
                        space: 10,
                        child: InputBox(
                          inputLabel: 'Confirm Password',
                          placeHolder: '************',
                          update: (value) {
                            data.confirmedPassword = value;
                          },
                          isPassword: true,
                        ),
                      ),
                      Column(
                        children: [
                          CustomButton(
                            onPressed: () async {
                              if (data.checkRegisterData()) {
                                showSnackbar(context);
                              } else if (!data.passwordCheck()) {
                                showSnackbar(context,
                                    text: "Passwords don't match");
                              } else {
                                await data
                                    .register((verificationId, resendToken) {
                                  Register.verificationId = verificationId;
                                  Register.phoneNumber = data.phoneNumber;
                                  Register.password = data.password;
                                  Navigator.pushNamed(
                                      context, 'verification-page');
                                });
                              }
                            },
                            label: 'Register',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(context, '/');
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.resolveWith(
                                    (states) => EdgeInsets.zero,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Color.fromRGBO(41, 230, 1, 1),
                                          Color.fromRGBO(13, 157, 1, 1),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(
                                          0,
                                          0,
                                          400,
                                          10,
                                        ),
                                      ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
