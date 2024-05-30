
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/admin_main_page.dart';
import 'package:loksewa/screen/auth/login_screen.dart';
import 'package:loksewa/screen/courses/categories/course_screen.dart';
import 'package:loksewa/screen/customization/customize_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  var user = FirebaseAuth.instance.currentUser;
  String? imageURL;
  late TabController tabController;

  final NotchBottomBarController _notchBottomBarController =
      NotchBottomBarController();
  // late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    // loadBack();
    tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void setPages(int index) {
    setState(() {
      tabController.index = index;
    });
  }

  List<Widget> pages = <Widget>[
    CourseScreen(),
    // DesignCourseHomeScreen(),
    Center(
      child: Text("Exams"),
    ),
    Center(
      child: Text("History"),
    ),
    Center(
      child: Text("Packages"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _notchBottomBarController,
          durationInMilliSeconds: 50,
          elevation: 2,
          showBlurBottomBar: true,
          blurOpacity: 1,
          itemLabelStyle: TextStyle(color: Color.fromARGB(151, 255, 255, 255)),
          color: Color.fromARGB(255, 35, 35, 36),
          notchGradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.grey,
              Colors.black,
            ],
          ),
          bottomBarItems: [
            const BottomBarItem(
              inActiveItem: Icon(
                Icons.home_filled,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.home_filled,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Home',
            ),
            const BottomBarItem(
              inActiveItem: Icon(
                Icons.text_snippet_rounded,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.text_snippet_rounded,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Exams',
            ),
            const BottomBarItem(
              inActiveItem: Icon(
                Icons.history,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.history,
                color: Colors.blueAccent,
              ),
              itemLabel: 'History',
            ),
            const BottomBarItem(
              inActiveItem: Icon(
                Icons.balcony_outlined,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.balcony_outlined,
                color: Colors.blueAccent,
              ),
              itemLabel: 'Packages',
            ),
          ],
          onTap: (index) {
            tabController.index = index;
            setState(() {
            });
          },
          kIconSize: 20,
          kBottomRadius: 20),
      drawer: buildDrawer(),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) => setState(() {
        tabController.animateTo(index);
        // currentPageIndex = index;
      }),
      selectedIndex: tabController.index,
      elevation: 4,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.expand_more), label: 'Exams'),
        NavigationDestination(
            icon: Icon(Icons.restore_outlined), label: 'Results'),
        NavigationDestination(
            icon: Icon(Icons.phone_callback_sharp), label: 'Packages'),
      ],
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                CircleAvatar(child: Icon(Icons.man),),
                SizedBox(height: 10),
          Text(user?.displayName.toString() as String),
          Text(user?.email as String), 
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              setState(() {
                tabController.index = 0;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard_customize),
            title: Text('Customization'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomizeMainPage(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin'),
            onTap: () {
              // Navigator.pushNamed(context, "TypeScreenAdmin");
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMainPage(),));
            },
          ),
          Divider(height: 1,),
          ListTile(title: Text("Logout"),leading: Icon(Icons.logout_outlined),onTap: (){
            FirebaseAuth.instance.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
          },)
        ],
      ),
    );
  } //buildDrawer
}//class