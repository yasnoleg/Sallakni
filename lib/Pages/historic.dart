import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_app/Classes/hiveLocal_DB.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Pages/home.dart';
import 'package:medical_app/Pages/profile.dart';
import 'package:medical_app/Pages/service/show_client_location.dart';
import 'package:medical_app/Pages/timer/timer_widget.dart';


class Historic extends StatefulWidget {
  Historic({super.key,});

  @override
  State<Historic> createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  @override

  //LINK
  Couleur couleur = Couleur();
  HiveDB hiveDB = HiveDB();
  final user = FirebaseAuth.instance.currentUser;

  //LISTS
  late DocumentSnapshot<Object?> client;


  //init
  @override
  void initState() {
    if(hiveDB.bx.get("usermap") == null){
      hiveDB.InitUserMapData();
    }else{
      hiveDB.LoadUserMapData();
    }
    super.initState();
  }

  void Agree() {
    FirebaseFirestore.instance.collection('user').doc(client['clientEmail'].toString()).collection('demande').doc(client.id).update({
      'state': 'inProgress',
    });
    FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc(user!.email.toString()).collection('demande').doc(client.id).update({
      'state': 'inProgress',
    });
  }

  void Refuse() {
    FirebaseFirestore.instance.collection('user').doc(client['clientEmail'].toString()).collection('demande').doc(client.id).update({
      'state': 'refuse',
    });
    FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc(user!.email.toString()).collection('demande').doc(client.id).update({
      'state': 'refuse',
    });
  }

  void Done() {
    FirebaseFirestore.instance.collection('user').doc(client['clientEmail'].toString()).collection('demande').doc(client.id).update({
      'state': 'Done',
    });
    FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc(user!.email.toString()).collection('demande').doc(client.id).update({
      'state': 'Done',
    });
  }
  
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: couleur.White,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: couleur.White,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Name',style: LableTextStyle,),
                  Text('Type',style: LableTextStyle,),
                  Text('Date',style: LableTextStyle,),
                  Text('State',style: LableTextStyle,),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc('${user!.email}').collection('demande').snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.data!.docs.isNotEmpty ? hiveDB.usermap['type'] == 'user' ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context){
                        
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            title: Text('${data['name']}',style: StyleText,),
                            actions: <Widget>[
                              TextButton(
                                child: Text('REFUSE',style: MidTextStyle),
                                onPressed: () {
                                  setState(() {
                                    client = data;
                                  });
                                  Refuse();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('DONE',style: MidTextStyle),
                                onPressed: () {
                                  setState(() {
                                    client = data;
                                  });
                                  Done();
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(onPressed: () {Navigator.of(context).pop();}, icon: Icon(Icons.arrow_forward_ios_outlined,color: couleur.Black,)),
                            ],
                            content: Container(
                              width: 250.0,
                              height: 100.0,
                              child: Padding(
                                padding: EdgeInsets.only(right: width*0.06,left: width*0.06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height*0.01,),
                                    Text('- ${data['type']}',style: SmallTextStyle,),
                                    Text('- ${data['date']}',style: SmallTextStyle,),
                                    Text('- ${data['name']}',style: SmallTextStyle,),
                                  ]
                                  ),
                              )
                              )
                            );
                        }
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: width*0.05,right: width*0.05,bottom: height*0.03),
                      child: Container(
                        height: height*0.09,
                        decoration: BoxDecoration(
                          color: couleur.Grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(height*0.01)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('${data['name']}',style: MidTextStyle,),
                            SizedBox(),
                            data['state'] == 'inProgress' ? TimerWidget() : Text('${data['type']}',style: MidTextStyle,),
                            Text('${data['date']}',style: MidTextStyle,),
                            Container(
                              padding: EdgeInsets.all(height*0.006),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.005),
                                color:data['state'] == 'done' ? couleur.LightGreen : data['state'] == 'refuse' ? couleur.LightRed : data['state'] == 'inProgress' ? couleur.LightPurple : couleur.LightBlue,
                              ),
                              child: Text('${data['state']}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ) : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      data['state'] != 'refuse' ? showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context){
                        
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            title: Text('${data['name']} needs your services, now!',style: StyleText,),
                            actions: <Widget>[
                              TextButton(
                                child: Text('REFUSE',style: MidTextStyle),
                                onPressed: () {
                                  setState(() {
                                    client = data;
                                  });
                                  Refuse();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('GO',style: MidTextStyle),
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                                          child: ShowClientLocation(latitudeClient: data['latitude'], longitudeClient: data['longitude'], latitude: hiveDB.usermap['latitude'], longitude: hiveDB.usermap['longitude'],),
                                      );
                                    })
                                  );
                                },
                              ),
                              data['state'] != 'inProgress' || data['state'] != 'done'  ? TextButton(
                                child: Text('AGREE',style: MidTextStyle),
                                onPressed: () {
                                  setState(() {
                                    client = data;
                                  });
                                  print(client.id);
                                  Navigator.of(context).pop();
                                  Agree();
                                },
                              ) : data['state'] == 'done' ? TextButton(
                                child: Text('DONE',style: MidTextStyle),
                                onPressed: () {
                                  setState(() {
                                    client = data;
                                  });
                                  Done();
                                  Navigator.of(context).pop();
                                },
                              ) : Text(''),
                              IconButton(onPressed: () {Navigator.of(context).pop();}, icon: Icon(Icons.arrow_forward_ios_outlined,color: couleur.Black,)),
                            ],
                            content: Container(
                              width: 250.0,
                              height: 100.0,
                              child: Padding(
                                padding: EdgeInsets.only(right: width*0.06,left: width*0.06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height*0.01,),
                                    Text('- ${data['locality']}',style: SmallTextStyle,),
                                    Text('- ${data['date']}',style: SmallTextStyle,),
                                    Text('- (+213) ${data['clientNumber']}',style: SmallTextStyle,),
                                  ]
                                  ),
                              )
                              )
                            );
                        }
                        ) : null;
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: width*0.05,right: width*0.05,bottom: height*0.03),
                      child: Container(
                        height: height*0.09,
                        decoration: BoxDecoration(
                          color: couleur.Grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(height*0.01)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('${data['name']}',style: MidTextStyle,),
                            SizedBox(),
                            Text('${data['locality'].toString().substring(0,7)}...',style: MidTextStyle,),
                            Text('${data['date']}',style: MidTextStyle,),
                            Container(
                              padding: EdgeInsets.all(height*0.006),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.005),
                                color:data['state'] == 'done' ? couleur.LightGreen : data['state'] == 'refuse' ? couleur.LightRed : data['state'] == 'inProgress' ? couleur.LightPurple : couleur.LightBlue,
                              ),
                              child: Text('${data['state']}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ) : Lottie.network('https://assets7.lottiefiles.com/packages/lf20_qargqtj3.json');
            }),
          ),
        ],
      ),
    );
  }
}
