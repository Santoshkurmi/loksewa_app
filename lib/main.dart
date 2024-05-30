import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/type_screen.dart';
import 'package:loksewa/firebase_options.dart';
import 'package:loksewa/screen/home/home_screen.dart';
import 'package:loksewa/screen/auth/login_screen.dart';
import 'package:loksewa/screen/courses/categories/course_intro_screen.dart';
import 'package:loksewa/screen/courses/gk_and_IQ/GkAndIQScreen.dart';
import 'package:loksewa/screen/courses/syallbuspdf/syallbus_screen.dart';
import 'package:loksewa/screen/courses/categories/main_category_screen.dart';
import 'package:loksewa/screen/courses/categories/sub_category_screen.dart';
import 'package:loksewa/themes/my_themes.dart';
Future<void> main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const MyApp());
}


var routes = <String,WidgetBuilder>{
  "/LoginScreen" :  (BuildContext context) => LoginScreen(),
  // "/SplashScreen" :  (BuildContext context) => const IntroductionAnimationScreen(),
  "/HomeScreen" :  (BuildContext context) => HomeScreen(),
  "CourseIntroScreen":  (BuildContext context) => CourseIntroScreen(),
  "SyallbusScreen":  (BuildContext context) => SyallbusScreen(),
  "GkAndIQScreen":  (BuildContext context) => GkAndIQScreen(),
  "MainCategoryScreen":  (BuildContext context) => MainCategoryScreen(),
  "SubCategoryScreen":  (BuildContext context) => SubCategoryScreen(),
  "TypeScreenAdmin":  (BuildContext context) => TypeScreen(),
  "AddTypeScreen":  (BuildContext context) => AddTypeScreen(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learning',
      debugShowCheckedModeBanner: false,
      routes: routes,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.mouse,PointerDeviceKind.touch}),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme.apply(bodyColor: Color.fromARGB(255, 0, 0, 0)) ),
        // canvasColor: secondaryColor,
      ),
      darkTheme: MyAppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      
      home: FirebaseAuth.instance.currentUser == null? SafeArea(child: LoginScreen()): HomeScreen(),
      // home: MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(
      //       create: (context)=>MenuAppController(),
      //       ),
      //   ],
      //   child: MainScreen(),
      //   ),
    );
  }
}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
