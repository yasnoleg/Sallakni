import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:medical_app/Classes/firebase_services.dart';
import 'package:medical_app/Classes/hiveLocal_DB.dart';
import 'package:medical_app/Classes/locationServices.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_in.dart';


class SignUpPage extends StatefulWidget {
  VoidCallback showSignInPage;
  SignUpPage({super.key, required this.showSignInPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  //LINK  
  Couleur couleur = Couleur();
  SignUpWithGmail signUpwidthGmail = SignUpWithGmail();

  //VARS
  String type = 'repair';
  String email = '';
  double _latitude = 0;
  double _longitude = 0;
  late LocationData _locatioDT;

  //TEXTEDITING CONTROLLERS
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _firstnamecontroller = TextEditingController();
  TextEditingController _lastnamecontroller = TextEditingController();
  TextEditingController _phonenumbercontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confpasswordcontroller = TextEditingController();

  //GLOBAL KEY
  final _key = GlobalKey<FormState>();
  HiveDB hiveDB = HiveDB();
  LocationService locationservice = LocationService();

  //SHOW PASSWORD
  bool showPass = true;
  bool showConPass = true;

  @override
  void initState() {
    if(hiveDB.bx.get("usermap") == null){
      hiveDB.InitUserMapData();
    }else{
      hiveDB.LoadUserMapData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _usernamecontroller.dispose();
    _firstnamecontroller.dispose();
    _lastnamecontroller.dispose();
    _phonenumbercontroller.dispose();
    _passwordcontroller.dispose();
    _confpasswordcontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double MyHeight = MediaQuery.of(context).size.height;
    double MyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: couleur.White,
      appBar: AppBar(
        title: Text('Hi !', style: HugeTitleStyle,),
        elevation: 0,
        backgroundColor: couleur.White,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: MyWidth*0.065,right: MyWidth*0.065),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //TEXT ' GET CLOSE TO THE DOCTOR '
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: MyHeight*0.02,top: MyHeight*0.02),
                      child: const Text('We are always at your service', style: StyleText,),
                    ),
                  ],
                ),
          
                //TEXTFIELD EMAIL
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if(value!.contains('@gmail.com') || value.contains('@yahoo.com') || value.contains('@service.com')){
                        return null;
                      }else{
                        return 'address email not valide';
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
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
                
                //TEXTFIELD USERNAME
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _usernamecontroller,
                    validator: (value) {
                      if(value != null){
                        return null;
                      }else{
                        return 'not valide';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'yourname',
                      hintStyle: HintTextStyle,
                      labelStyle: LableTextStyle,
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: couleur.LightBlue
                      ),
                      label: const Text('Username'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MyHeight*0.02),
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: couleur.LightBlue.withOpacity(0.1)
                    ),
                  ),
                ),
                
                //TEXTFIELD FIRESTNAME
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _firstnamecontroller,
                    validator: (value) {
                      if(value != null){
                        return null;
                      }else{
                        return 'not valide';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'first name',
                      hintStyle: HintTextStyle,
                      labelStyle: LableTextStyle,
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: couleur.LightBlue
                      ),
                      label: const Text('First Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MyHeight*0.02),
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: couleur.LightBlue.withOpacity(0.1)
                    ),
                  ),
                ),
                
                //TEXTFIELD LASTNAME
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _lastnamecontroller,
                    validator: (value) {
                      if(value != null){
                        return null;
                      }else{
                        return 'not valide';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'last name',
                      hintStyle: HintTextStyle,
                      labelStyle: LableTextStyle,
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: couleur.LightBlue
                      ),
                      label: const Text('Last Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MyHeight*0.02),
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: couleur.LightBlue.withOpacity(0.1)
                    ),
                  ),
                ),
                
                //TEXTFIELD PHONENUMBER
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _phonenumbercontroller,
                    validator: (value) {
                      if(value != null){
                        return null;
                      }else{
                        return 'not valide';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'phone number',
                      hintStyle: HintTextStyle,
                      labelStyle: LableTextStyle,
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: couleur.LightBlue
                      ),
                      label: const Text('Phone Number'),
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
                    validator: (value) {
                      if(value!.length < 6){
                        return 'password is very small';
                      }else{
                        return null;
                      }
                    },
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
                      hintText: 'new password',
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
                
                //TEXTFIELD CONFIRM PASSWORD
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.015),
                  child: TextFormField(
                    controller: _confpasswordcontroller,
                    validator: (value) {
                      if(_passwordcontroller.text.trim() == value){
                        return null;
                      }else{
                        return 'verify your password';
                      }
                    },
                    obscureText: showConPass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            showConPass = !showConPass;
                          });
                        },
                        child: Icon(showConPass ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                      ),
                      hintText: 'your password',
                      hintStyle: HintTextStyle,
                      labelStyle: LableTextStyle,
                      floatingLabelStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: couleur.LightBlue
                      ),
                      label: const Text('ConfirmPassword'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(MyHeight*0.02),
                        borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: couleur.LightBlue.withOpacity(0.1)
                    ),
                  ),
                ),

                email.contains('service') ? Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.015),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: MyHeight*0.02, left: MyHeight*0.02),
                    height: MyHeight*0.072,
                    decoration: BoxDecoration(
                      color: couleur.LightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(MyHeight*0.02),
                    ),
                    child: DropdownButton<String>(
                      style: LableTextStyle,
                      borderRadius: BorderRadius.circular(MyHeight*0.015),
                      elevation: 4,
                      isExpanded: true,
                      underline: Container(),
                      value: type,
                      items: <String>['repair', 'taxi']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: MyHeight*0.023),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                    ),
                  ),
                ) : Container() ,

                //YOU HAVE AN ACCOUNT !
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.055,left: MyWidth*0.005),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('You have an account !', style: SmallTextStyle,),
                      GestureDetector(
                        onTap: () {
                          widget.showSignInPage();
                        },
                        child: Text.rich(
                          TextSpan(text: '  Sign-In',style: TextStyle(color: couleur.LightBlue,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'text'),),
                        ),
                      ),
                    ],
                  ),
                ),
                
                //BUTTON SIGN UP
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(_key.currentState!.validate()){
                              if(_emailcontroller.text.trim().contains('@service')){
                                print('service');
                              }else{
                                setState(() {
                                  type = 'user';
                                });
                              }
                              print(type);
                              //1
                              Future.delayed(Duration(seconds: 2), () {
                                SignUpMethod(_emailcontroller.text.trim(), _passwordcontroller.text.trim(), _usernamecontroller.text.trim(), _firstnamecontroller.text.trim(), _lastnamecontroller.text.trim(), _phonenumbercontroller.text.trim(), type);
                              });
                            }
                          }, 
                          child: Text('SIGN-UP',style: TextStyle(color: couleur.White,fontSize: 18,fontFamily: 'small_title'),),
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
                
                //DIVIDER ' OR SIGN UP WITH '
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Text('  Or Sign-Up With  ',style: SmallTextStyle,),
                    Expanded(child: Divider()),
                  ],
                ),
                
                //SIGN UP WITH GMAIL
                Padding(
                  padding: EdgeInsets.only(top: MyHeight*0.02,bottom: MyHeight*0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //WITH GMAIL
                      ElevatedButton(
                          onPressed: () async { 
                            signUpwidthGmail.signUpWithGoogle();
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
      ),
    );
  }
}