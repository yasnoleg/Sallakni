import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/Classes/firebase_services.dart';
import 'package:medical_app/Classes/hiveLocal_DB.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //MAP
  Map<String, dynamic> UserMap = {};

  //CURRENT USER TO READ USER INFORMATION
  final user = FirebaseAuth.instance.currentUser;
  final Instance = FirebaseFirestore.instance;

  //LINK 
  Couleur couleur = Couleur();
  HiveDB hiveDB = HiveDB();

  //XFile
  XFile? imag_e;

  //FUNCTIONS
  GetUserMap() {
    //1
    print(UserMap);
    if(UserMap.isEmpty){
      Instance.collection('user').doc('${user!.email}').get().then((value) {
        setState(() {
          UserMap = value.data()!;
          hiveDB.usermap = UserMap;
          hiveDB.UpdateUserMapData();
        });
      });
      print(UserMap);
      if(UserMap.isEmpty){
        Instance.collection('repair').doc('${user!.email}').get().then((value) {
          setState(() {
            UserMap = value.data()!;
            hiveDB.usermap = UserMap;
            hiveDB.UpdateUserMapData();
          });
        });
        print(UserMap);
        if(UserMap.isEmpty){
          Instance.collection('repair').doc('${user!.email}').get().then((value) {
            setState(() {
              UserMap = value.data()!;
              hiveDB.usermap = UserMap;
              hiveDB.UpdateUserMapData();
            });
          });
          print(UserMap);
        }
      }
    }
  }

  //Choose profile picture 
  chooseProfilePic() async {
    final imagefile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    setState(() {
      imag_e = imagefile;
      hiveDB.imagepath = imagefile!.path.toString();
    });
    hiveDB.UpdatePath();
  }

  
  @override
  void initState() {
    if(hiveDB.bx.get("usermap") == null){
      hiveDB.InitUserMapData();
    }else{
      hiveDB.LoadUserMapData();
    }
    if(hiveDB.bx.get("path") == null){
      hiveDB.InitPath();
    }else{
      hiveDB.LoadPath();
    }
    //1
    GetUserMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT / WIDTH var
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    //USER INFO
    var UserEmail = user!.email;
    return Scaffold(
      backgroundColor: couleur.White,
      body: Padding(
        padding: EdgeInsets.only(top: height*0.015,bottom: height*0.015,right: height*0.015,left: height*0.015),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    chooseProfilePic();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height*0.025),
                    child:  hiveDB.imagepath.isEmpty ? Image.asset('asset/avatars/profilePic.png',height: height*0.16,width: height*0.16) : Image.file(File(hiveDB.imagepath),height: height*0.16,width: height*0.16,fit: BoxFit.cover,),
                  ),
                ),
                SizedBox(width: width*0.05,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //PROFILE PICTURE
                    Row(
                      children: [
                        Text('${hiveDB.usermap['username']}',style: TitleStyle,),
                        SizedBox(width: height*0.01,),
                        Container(
                          height: height*0.027,
                          width: width*0.12,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 214, 214, 214).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(height*0.05)
                          ),
                          child: Text(user!.email.toString().contains('service') ? 'service' :'user'),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.01,),
                    //FIRSTNAME + LASTNAME
                    RichText(
                      text: 
                      TextSpan(
                        text: '${hiveDB.usermap['firstname']} ',
                        style: StyleText,
                        children: [
                          TextSpan(text: '${hiveDB.usermap['lastname']}',style: StyleText,)
                        ]
                      ),
                    ),
                    SizedBox(height: height*0.01,),
                    //EMAIL
                    Text('${hiveDB.usermap['email']}',style: SmallTextStyle,),
                    SizedBox(height: height*0.01,),
                    //COUNTRY + LOCALITY
                    RichText(
                      text: 
                      TextSpan(
                        text: '${hiveDB.usermap['country']}, ',
                        style: SmallTextStyle,
                        children: [
                          TextSpan(text: '${hiveDB.usermap['locality']}',style: SmallTextStyle,)
                        ]
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          
            Padding(
              padding: EdgeInsets.only(left: width*0.03,right: width*0.03,bottom: height*0.01,top: height*0.03),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: '${hiveDB.usermap['username']}'),
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle_outlined),
                  labelText: 'Username',
                  labelStyle: LableTextStyle,
                ),
              ),
            ),
          
            Padding(
              padding: EdgeInsets.only(left: width*0.03,right: width*0.03,bottom: height*0.01),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: '${hiveDB.usermap['email']}'),
                decoration: InputDecoration(
                  icon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  labelStyle: LableTextStyle,
                ),
              ),
            ),
          
            Padding(
              padding: EdgeInsets.only(left: width*0.03,right: width*0.03,bottom: height*0.01,top: height*0.03),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: '${hiveDB.usermap['country']} ,${hiveDB.usermap['locality']}'),
                decoration: InputDecoration(
                  icon: Icon(Icons.location_on_outlined),
                  labelText: 'Adress',
                  labelStyle: LableTextStyle,
                ),
              ),
            ),
          
            Padding(
              padding: EdgeInsets.only(left: width*0.03,right: width*0.03,bottom: height*0.01,top: height*0.03),
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: '(+123)  ${hiveDB.usermap['phonenumber']}'),
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone number',
                  labelStyle: LableTextStyle,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: width*0.03,right: width*0.03,bottom: height*0.01,top: height*0.01),
              child: GestureDetector(
                onTap: () {
                  print(hiveDB.usermap);
                  showModalBottomSheet(
                    context: context, 
                    isDismissible: true,
                    enableDrag: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    ),
                    builder: ((context) {
                      return Container(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom
                          ),
                          child: SettingsPage(email: hiveDB.usermap['email'], username: hiveDB.usermap['username'], firstname: hiveDB.usermap['firstname'], lastname: hiveDB.usermap['lastname'], phonenumber: hiveDB.usermap['phonenumber']),
                      );
                    })
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined,color: couleur.LightPurple,),
                    SizedBox(width: width*0.02,),
                    Text('Modify your information',style: TextStyle(color: couleur.LightPurple),),
                  ],
                )),
            )
          ],
        ),
      ),
    );
  }
}