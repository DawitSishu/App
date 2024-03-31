import 'package:flutter/material.dart';
import 'package:health_app/util/components.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String phoneNumber = "";

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
      body: SingleChildScrollView(
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
                  'Reset Your Password',
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
                  'Please Enter the Phone number You used to create your account and if you have an account verification Message will be sent to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Phone Number',
                  placeHolder: 'Phone Number',
                  isPhone: true,
                  update: (value) {
                    phoneNumber = value;
                    print(phoneNumber);
                  },
                ),
              ),
              SizedBox(height: 70),
              CustomButton(
                onPressed: () {},
                label: 'Continue',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
