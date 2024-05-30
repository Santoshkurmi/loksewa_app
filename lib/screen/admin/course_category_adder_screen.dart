import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/category_screen_admin.dart';
import 'package:loksewa/screen/admin/course_category_shower.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';
import 'package:loksewa/screen/courses/model/courses.dart';

class CourseCategoryAdderScreen extends StatefulWidget {
  CourseCategoryAdderScreen({super.key});
  @override
  State<CourseCategoryAdderScreen> createState() => _TypeScreen();
}

class _TypeScreen extends State<CourseCategoryAdderScreen> {
  List<dynamic> courses = [];
  bool isFetched = true;
  final DatabaseReference reference = FirebaseDatabase.instance.ref("/types");


  @override
  void initState() {
    super.initState();
    
    datas.forEach((element) {
      
      List<dynamic> course = element["courses"];
      String title = element["title"];
      course.forEach((elem) {
        courses.add({
          "mainCourse":title,
          "title":elem["title"],
          "id":elem["id"],
          // "categories":elem["categoriesMCQId"]
        }); 
      });//inner loop

    });//outer loop
    // fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        // Navigator.pushNamed(context, "CategoryScreenAdmin",arguments: {"type":types.elementAt(index)["type"]});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseCategoryShowerScreen(
                              id: courses.elementAt(index)["id"],
                              )
                            ));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(courses.elementAt(index)["title"]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  } //build
}//_TypeScreen