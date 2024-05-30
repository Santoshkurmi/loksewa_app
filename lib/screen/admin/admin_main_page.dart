import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/category_screen_admin.dart';
import 'package:loksewa/screen/admin/course_category_adder_screen.dart';
import 'package:loksewa/screen/admin/course_category_chooser.dart';
import 'package:loksewa/screen/admin/customization_main_page.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';
import 'package:loksewa/screen/admin/type_screen.dart';

class AdminMainPage extends StatefulWidget {
  AdminMainPage({super.key});
  @override
  State<AdminMainPage> createState() => _TypeScreen();
}

class _TypeScreen extends State<AdminMainPage> {

  List<String> actions = ["Create New Data","Link Category to course","Customization"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Actions"),
      ),
      body:Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        if(index==0){
                          Navigator.push(context, MaterialPageRoute(builder: (con){
                            return TypeScreen();
                          }));
                        }//if
                        else if(index==1){

                          Navigator.push(context, MaterialPageRoute(builder: (con){
                            return CourseCategoryAdderScreen();
                          }));
                        }//else if
                        else if(index==2){

                          Navigator.push(context, MaterialPageRoute(builder: (con){
                            return CustomizationMainPage();
                          }));
                        }//else if
                      },
                      child: Card(
                        color:index ==0? Colors.purple.shade700: null,
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
            )
    );
  } //build
}//_TypeScreen