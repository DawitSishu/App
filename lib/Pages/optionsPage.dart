import 'package:flutter/material.dart';
import 'package:health_app/util/components.dart';
import 'package:http/http.dart' as http;
import '../models/SignInPageData.dart';
import 'registerPage.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});
  static var employee = true;
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isEmployee = true;

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
              const WidgetSpace(
                space: 18,
                child: Text(
                  'Choose Your Category',
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
                  'Choose whether you are looking for a job or you are an organization / company that needs employees.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.3,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
              ),
              WidgetSpace(
                space: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 2,
                              color: isEmployee
                                  ? const Color.fromRGBO(44, 113, 254, 1)
                                  : const Color.fromRGBO(239, 239, 239, 1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          if (!isEmployee) {
                            setState(() {
                              OptionsPage.employee = true;
                              isEmployee = true;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(238, 244, 255, 1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.work_rounded,
                                  color: Color.fromRGBO(52, 118, 254, 1),
                                ),
                              ),
                              const WidgetSpace(
                                space: 30,
                                child: Text(
                                  'Job Seeker',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'I want to find a job for me',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.3,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
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
                              color: !isEmployee
                                  ? const Color.fromRGBO(44, 113, 254, 1)
                                  : const Color.fromRGBO(239, 239, 239, 1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          if (isEmployee) {
                            setState(() {
                              OptionsPage.employee = false;
                              isEmployee = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 247, 235, 1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.business_rounded,
                                  color: Color.fromRGBO(254, 160, 29, 1),
                                ),
                              ),
                              const WidgetSpace(
                                space: 30,
                                child: Text(
                                  'Recruiter',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'I want to find employees',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.3,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: CustomButton(
                  onPressed: () async{
                      await Navigator.pushNamed(
                        context,
                        'register-page',);
                  },
                  label: 'Continue',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
