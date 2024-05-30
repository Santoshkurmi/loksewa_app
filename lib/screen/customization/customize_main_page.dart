import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/customization_main_page.dart';
import 'package:loksewa/screen/admin/type_screen.dart';
import 'package:loksewa/screen/customization/change_ui_background.dart';

class CustomizeMainPage extends StatefulWidget {
  CustomizeMainPage({super.key});
  @override
  State<CustomizeMainPage> createState() => _TypeScreen();
}

class _TypeScreen extends State<CustomizeMainPage> {
  List<String> actions = [
    "Question Answer Background",
    "Question Answer foreground",
    "Home Screen Background",
    "Course Intro Background",
    "Categories Background",
    "Sub-Categories Background",
    "Reset Every Customization"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Customize background"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: ListView.builder(
            itemCount: actions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (con) {
                      return ChangeUIBackground(id: index,);
                    }));
                    return;
                  },
                  child: Card(
                    // color:index ==0? Colors.purple.shade700: null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(actions.elementAt(index)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  } //build
}//_TypeScreen