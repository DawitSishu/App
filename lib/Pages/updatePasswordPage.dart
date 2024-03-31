import 'package:flutter/material.dart';
import 'package:health_app/util/components.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String password = "";
  String confirmPassword = "";

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
                  'Please Enter your new updated password.',
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
                  inputLabel: 'New Password',
                  placeHolder: 'New Password',
                  isPhone: true,
                  update: (value) {
                    password = value;
                    print(password);
                  },
                ),
              ),
              WidgetSpace(
                space: 20,
                child: InputBox(
                  inputLabel: 'Confirm Password',
                  placeHolder: 'Confirm Password',
                  isPhone: true,
                  update: (value) {
                    confirmPassword = value;
                    print(confirmPassword);
                  },
                ),
              ),
              SizedBox(height: 70),
              CustomButton(
                onPressed: () {},
                label: 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
