import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/Pages/HealthInstitutionHomePage.dart';
import 'package:health_app/Pages/HealthProfessionalHomePage.dart';
import 'package:health_app/Pages/JobDetailsPage.dart';
import 'package:health_app/Pages/JobPostPage.dart';
import 'package:health_app/Pages/OrganizationInfoPage.dart';
import 'package:health_app/Pages/OrganizationInfoPage2.dart';
import 'package:health_app/Pages/PendingPaymentPage.dart';
import 'package:health_app/Pages/VerificationPage.dart';
import 'package:health_app/Pages/companyJobsPage.dart';
import 'package:health_app/Pages/documentsPage.dart';
import 'package:health_app/Pages/experiencePage.dart';
import 'package:health_app/Pages/forgotPasswordPage.dart';
import 'package:health_app/Pages/gettingStartedPage.dart';
import 'package:health_app/Pages/optionsPage.dart';
import 'package:health_app/Pages/paymentPage.dart';
import 'package:health_app/Pages/personalInfoPage.dart';
import 'package:health_app/Pages/personalSettingsPage.dart';
import 'package:health_app/Pages/proffesionalDetailsPage.dart';
import 'package:health_app/Pages/registerPage.dart';
import 'package:health_app/Pages/signIn.dart';
import 'package:health_app/Pages/updatePasswordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final x = await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  var firstTime = prefs.getBool('firstTime');
  final token = prefs.getString('token');
  final userType = prefs.getString('userType');

  var loggedIn = false;
  late String initialRoute;

  if (Firebase.apps.isNotEmpty) {
    print('Firebase has been successfully initialized');
  } else {
    print('Firebase failed to initialize');
  }

  firstTime ??= true;
  if (token != null) {
    loggedIn = true;
  }

  if (firstTime) {
    initialRoute = 'getting-started';
  } else if (loggedIn) {
    if (userType == 'professional') {
      initialRoute = 'health-professional-page';
    } else {
      initialRoute = 'health-institution-page';
    }
  } else {
    initialRoute = '/';
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Health App',
    theme: ThemeData(
      fontFamily: 'Poppins',
    ),
    initialRoute: '/',
    routes: {
      'getting-started': (context) => GettingStartedPage(),
      // 'pp': (context) => const ORTest(),
      '/': (context) => const SignIn(),
      'register-page': (context) => const Register(),
      'options-page': (context) => OptionsPage(),
      'personal-info-page': (context) => PersonalInfo(),
      'organization-page-info': (context) => OrganizationInfo(),
      'organization-page-info2': (context) => OrganizationInfo2(),
      'experience-page': (context) => ExperiencePage(),
      'documents-page': (context) => Documents(),
      'health-professional-page': (context) => HealthProfessionalHome(),
      'health-institution-page': (context) => HealthInstitutionHome(),
      'verification-page': (context) => VerificationPage(),
      'job-detail-page': (context) => JobDetails(),
      'job-post-page': (context) => JobPost(),
      'personal-settings-page': (context) => const PersonalSettings(),
      'payment-page': (context) => PaymentPage(),
      'company-Jobs': (context) => CompanyJobs(),
      'proffesional-details-page': (context) => ProffesionalDetails(),
      'pending-payment-page': (context) => PendingPayment(),
    },
  ));
}
