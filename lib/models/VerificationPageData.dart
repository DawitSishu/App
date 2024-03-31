import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/registerPage.dart';
import 'SignInPageData.dart';

class VerificationData {
  final signInObj = SignInData(password: Register.password, phoneNumber: Register.phoneNumber);
  FirebaseAuth auth = FirebaseAuth.instance;

  VerificationData({this.Pin = ''});
  String Pin;
  void printVerificationData() {
    print(Pin);
  }

  verifyAndSignIn() async{
    try{
      final credential = PhoneAuthProvider.credential(verificationId: Register.verificationId, smsCode: Pin);
      final email = Register.phoneNumber + '@healthApp.com';
      await auth.signInWithCredential(credential);

      final signedIn = await signInObj.register();
      if(!signedIn['success']){
        return {'success': false, 'error': signedIn['error']};
      }
      return {'success': true, 'error': {}};
    }catch(e){
      return {'success': false, 'error': e};
    }
  }

}
