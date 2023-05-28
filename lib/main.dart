import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_app/Auth/auth_page.dart';
import 'package:medical_app/Classes/TheTimer.dart';
import 'package:medical_app/Classes/location_controller.dart';
import 'package:medical_app/Classes/providers/city_provider.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Log_In_Up_Out_System/Pages/sign_up.dart';
import 'package:medical_app/Pages/historic.dart';
import 'package:medical_app/Pages/home.dart';
import 'package:medical_app/Pages/profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //OPEN HIVE BOX
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  Get.put(LocationController());
  Get.put(TimerController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityProvider()),
      ],
      child: MaterialApp(home: AuthPage()),
    )
  );
}


class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedindex = 1;

  List<Widget> pages = [
    Historic(),
    MapSample(),
    ProfilePage(),
  ];

  //LINK
  Couleur couleur = Couleur();


  @override
  Widget build(BuildContext context) {

    //Sizes
    double Hight = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: selectedindex == 1 ? null : AppBar(
        elevation: 0,
        title: Text(selectedindex == 0 ? 'History' : 'Profile', style: TitleStyle,),
        backgroundColor: couleur.White,
        centerTitle: false,
        actions: <Widget>[
          IconButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, icon: Image.asset('asset/icons/logout.png'))
        ],
      ),
      body: pages[selectedindex],
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: couleur.White,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: couleur.White,
                hoverColor: couleur.White,
                gap: 8,
                activeColor: couleur.Black,
                iconSize: Hight*0.04,
                padding: EdgeInsets.symmetric(horizontal: Hight*0.03, vertical: Hight*0.010),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: couleur.White,
                tabs: [
                  GButton(
                    leading: Image.asset('asset/icons/history.png',height: Hight*0.065,width: Width*0.065,color: couleur.Black,),
                    icon: Icons.home,
                    text: 'History',
                    iconColor: couleur.Black,
                  ),
                  GButton(
                    leading: Image.asset('asset/icons/home-button.png',height: Hight*0.065,width: Width*0.065,color: couleur.Black,),
                    icon: Icons.add_circle_outline,
                    text: 'Home',
                    iconColor: couleur.Black,
                  ),
                  GButton(
                    leading: Image.asset('asset/icons/profile.png',height: Hight*0.065,width: Width*0.065,color: couleur.Black,),
                    icon: Icons.account_circle_outlined,
                    text: 'Profile',
                    iconColor: couleur.Black,
                  ),
                ],
                selectedIndex: selectedindex,
                onTabChange: (index) {
                  setState(() {
                    selectedindex = index;
                  });
                },
              ),
            ),
          ),
      ),
    );
  }
}