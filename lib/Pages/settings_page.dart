import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:medical_app/Classes/hiveLocal_DB.dart';
import 'package:medical_app/Classes/locationServices.dart';
import 'package:medical_app/Classes/tools.dart';

class SettingsPage extends StatefulWidget {
  String email;
  String username;
  String firstname;
  String lastname;
  String phonenumber;
  SettingsPage({super.key, required this.email, required this.username,required this.firstname, required this.lastname, required this.phonenumber});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  //LINK  
  Couleur couleur = Couleur();

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
    _emailcontroller.text = widget.email;
    email = widget.email;
    _usernamecontroller.text = widget.username;
    _firstnamecontroller.text = widget.firstname;
    _lastnamecontroller.text = widget.lastname;
    _phonenumbercontroller.text = widget.phonenumber;
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _usernamecontroller.dispose();
    _firstnamecontroller.dispose();
    _lastnamecontroller.dispose();
    _phonenumbercontroller.dispose();
    super.dispose();
  }

  ModifyUserInfo() async {
    await FirebaseFirestore.instance.collection(type).doc(email).update({
      'username': _usernamecontroller.text.trim(),
      'firstname': _firstnamecontroller.text.trim(),
      'lastname': _lastnamecontroller.text.trim(),
      'phonenumber': _phonenumbercontroller.text.trim(),
      'type': type,
    });
    await FirebaseFirestore.instance.collection(type).doc(email).get().then((value) {
      setState(() {
        hiveDB.usermap = value.data()!;
        hiveDB.UpdateUserMapData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double MyHeight = MediaQuery.of(context).size.height;
    double MyWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
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
                      child: const Text('Change your info if you want', style: StyleText,),
                    ),
                  ],
                ),
          
                //TEXTFIELD EMAIL
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.025),
                  child: TextFormField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
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
                    keyboardType: TextInputType.number,
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
                
                //DIVIDER ' OR SIGN UP WITH '
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Text('  So  ',style: SmallTextStyle,),
                    Expanded(child: Divider()),
                  ],
                ),

                //BUTTON SIGN UP
                Padding(
                  padding: EdgeInsets.only(bottom: MyHeight*0.02,top: MyHeight*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(_key.currentState!.validate()){
                              ModifyUserInfo();
                              Navigator.of(context).pop();
                              print(hiveDB.usermap);
                            }
                          }, 
                          child: Text('Modify',style: TextStyle(color: couleur.White,fontSize: 18,fontFamily: 'small_title'),),
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
              ],
            ),
          ),
        ),
    );
  }
}