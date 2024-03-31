import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/models/SignInPageData.dart';
import 'package:health_app/util/components.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final data = SignInData();

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
                              'Sign in to',
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
                        space: 5,
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
                        space: 5,
                        child: Column(
                          children: [
                            InputBox(
                              inputLabel: 'Password',
                              placeHolder: '************',
                              update: (value) {
                                data.password = value;
                              },
                              isPassword: true,
                            ),
                            // not functional yet
                            // Row(
                            //   children: <Widget>[
                            //     MyCheckbox(),
                            //     const Text(
                            //       'Remember me',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.w300,
                            //         fontSize: 12,
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CustomButton(
                            onPressed: () async {
                              if (data.checksignIn()) {
                                showSnackbar(context);
                              } else {
                                var signSuccess = await data.signIn();
                                if (signSuccess['success']) {
                                  Navigator.popAndPushNamed(
                                    context,
                                    signSuccess['route'],
                                  );
                                } else {
                                  final error = signSuccess['error']
                                      .toString()
                                      .replaceAll(RegExp(r'\[.*\]'), '');
                                  showSnackbar(context, text: error);
                                }
                              }
                            },
                            label: 'Login',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    'options-page',
                                  );
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.resolveWith(
                                    (states) => EdgeInsets.zero,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Register',
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
                              )
                            ],
                          ),
                          // to be implemnted once the forgot password is done
                          // Center(
                          //   child: TextButton(
                          //     onPressed: () {

                          //     },
                          //     style: const ButtonStyle(
                          //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     ),
                          //     child: const Text(
                          //       'Forgot your password?',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.w300,
                          //         fontSize: 12,
                          //         color: Color.fromRGBO(80, 137, 255, 1),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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

class MyCheckbox extends StatefulWidget {
  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked =
              value!; // Toggle the value by using the value passed in onChanged
        });
      },
    );
  }
}
