import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


//CLASS TO SIGN IN / SIGN UP / SIGNOUT TO FIREBASE
SignInMethod(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email, 
    password: password,
  ).then((value) => print('///////////////////////////////////${value}===================================================='));
}

SignUpMethod(String email, String password,  String username, String firstname, String lastname, String phonenumber, String type) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email, 
    password: password,
  );
  UploadUserInfoToFireStrore(email, password, username, firstname, lastname, phonenumber, type);
}

UploadUserInfoToFireStrore(String email, String password ,String username, String firstname, String lastname, String phonenumber, String type) async {
  await FirebaseFirestore.instance.collection(type).doc(email).set({
    'email': email,
    'password': password,
    'username': username,
    'firstname': firstname,
    'lastname': lastname,
    'phonenumber': phonenumber,
    'type': type,
  });
}

SignOutMethod() async {
  await FirebaseAuth.instance.signOut();
}
//--------------------------------------------------------------------------------------------


//CREATE ACCOUNT WITH GMAIL
class SignUpWithGmail {
  signUpWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtaiin auth details from request 
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user 
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, lets sign in 
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtaiin auth details from request 
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user 
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
//------------------------------------------------------------------------
