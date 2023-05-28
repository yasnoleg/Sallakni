import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical_app/Classes/firebase_services.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_up.dart';


class SignInPage extends StatefulWidget {
  VoidCallback showSignUpPage;
  SignInPage({super.key, required this.showSignUpPage});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  //LINK TOOLS FILE 
  Couleur couleur = Couleur();
  SignUpWithGmail signUpwidthGmail = SignUpWithGmail();

  //TEXTEDITING CONTROLLERS
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confpasswordcontroller = TextEditingController();

  //SHOW PASSWORD
  bool showPass = true;

  

  Future SignIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailcontroller.text.trim(), 
      password: _passwordcontroller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double MyHeight = MediaQuery.of(context).size.height;
    double MyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: couleur.White,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: MyWidth*0.065,right: MyWidth*0.065,top: MyHeight*0.08,bottom: MyHeight*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //TITLE ' HI ! '
              Padding(
                padding: EdgeInsets.only(bottom: MyHeight*0.025),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('WELCOME !', style: HugeTitleStyle,),
                  ],
                ),
              ),
              
              //TEXT ' GET CLOSE repair '
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: MyHeight*0.06),
                    child: const Text('We are always closer', style: StyleText,),
                  ),
                ],
              ),

              //TEXTFIELD EMAIL
              Padding(
                padding: EdgeInsets.only(bottom: MyHeight*0.025),
                child: TextFormField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'yourname@gmail.com',
                    hintStyle: HintTextStyle,
                    label: const Text('Email'),
                    labelStyle: LableTextStyle,
                    floatingLabelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: couleur.LightBlue
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MyHeight*0.02),
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: couleur.LightBlue.withOpacity(0.1)
                  ),
                ),
              ),
              
              //TEXTFIELD PASSWORD
              Padding(
                padding: EdgeInsets.only(bottom: MyHeight*0.025),
                child: TextFormField(
                  controller: _passwordcontroller,
                  obscureText: showPass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: Icon(showPass ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                      ),
                      hintText: 'your password',
                    hintStyle: HintTextStyle,
                    labelStyle: LableTextStyle,
                    floatingLabelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: couleur.LightBlue
                    ),
                    label: const Text('Password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(MyHeight*0.02),
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: couleur.LightBlue.withOpacity(0.1)
                  ),
                ),
              ),
      
              //YOU DON'T HAVE AN ACCOUNT !
              Padding(
                padding: EdgeInsets.only(bottom: MyHeight*0.055,left: MyWidth*0.005),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You don't have an account !", style: SmallTextStyle,),
                    GestureDetector(
                      onTap: () {
                        widget.showSignUpPage();
                      },
                      child: Text.rich(
                        TextSpan(text: '  Sign-Up',style: TextStyle(color: couleur.LightBlue,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'text'),),
                      ),
                    ),
                  ],
                ),
              ),
      
              //BUTTON SIGN IN
              Padding(
                padding: EdgeInsets.only(bottom: MyHeight*0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () { 
                          SignInMethod(_emailcontroller.text.trim(), _passwordcontroller.text.trim());
                        }, 
                        child: Text('SIGN-IN',style: TextStyle(color: couleur.White,fontSize: 18,fontFamily: 'small_title'),),
                        // ignore: prefer_const_constructors
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(couleur.LightBlue),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(MyHeight*0.02),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all(Size(2, MyHeight*0.08))
                        ),
                      ),
                    ),
                  ],
                )
              ),
      
              //DIVIDER ' OR SIGN IN WITH '
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Text('  Or Sign-In With  ',style: SmallTextStyle,),
                  Expanded(child: Divider()),
                ],
              ),
      
              //SIGN IN WITH GMAIL | FACEBOOK
              Padding(
                padding: EdgeInsets.only(top: MyHeight*0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //WITH GMAIL
                    ElevatedButton(
                        onPressed: () { 
                          signUpwidthGmail.signInWithGoogle();
                         }, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email,color: Colors.red,),
                            SizedBox(width: MyWidth*0.04,),
                            Text('Gmail',style: ButtonTextStyle),
                          ],
                        ),
                        // ignore: prefer_const_constructors
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(couleur.White),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(MyHeight*0.02),
                              side: BorderSide(width: 0.2)
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all(Size(MyWidth*0.4, MyHeight*0.08)),
                          elevation: MaterialStateProperty.all(2)
                        ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}