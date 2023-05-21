import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/Auth/revise_auth_page.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_in.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_up.dart';
import 'package:medical_app/main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return MainPage();
          }else {
            return ReviseAuthPage();
          }
        },
      ),
    );
  }
}