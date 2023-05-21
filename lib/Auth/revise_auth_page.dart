import 'package:flutter/material.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_in.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_up.dart';

class ReviseAuthPage extends StatefulWidget {
  ReviseAuthPage({super.key});

  @override
  State<ReviseAuthPage> createState() => _ReviseAuthPageState();
}

class _ReviseAuthPageState extends State<ReviseAuthPage> {
  bool showSignIn_UpPage = true;

  ChangeSignPage() {
    setState(() {
      showSignIn_UpPage = !showSignIn_UpPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn_UpPage == true){
      return SignInPage(showSignUpPage: ChangeSignPage);
    }else{
      return SignUpPage(showSignInPage: ChangeSignPage);
    }
  }
}