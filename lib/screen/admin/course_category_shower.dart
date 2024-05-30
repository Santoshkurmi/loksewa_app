import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/category_screen_admin.dart';
import 'package:loksewa/screen/admin/course_category_adder_screen.dart';
import 'package:loksewa/screen/admin/course_category_chooser.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';
import 'package:loksewa/screen/courses/model/courses.dart';

class CourseCategoryShowerScreen extends StatefulWidget {
  int id;
  CourseCategoryShowerScreen({super.key,required this.id});
  @override
  State<CourseCategoryShowerScreen> createState() => _TypeScreen();
}

class _TypeScreen extends State<CourseCategoryShowerScreen> {
  List<dynamic> categories = [];
  bool isFetched = false;
  final DatabaseReference reference = FirebaseDatabase.instance.ref("/courses");

  void fetchTypes() {
    
    reference.child(widget.id.toString()).onValue.listen((DatabaseEvent event) {
      categories = [];
      categories.add({
        "key":"",
        "title":"Add more courses"
      });
      event.snapshot.children.forEach((element) {
        categories.add({
          "key": element.child("key").value,
          "title": element.child("title").value,
        });
      });
      setState(() {
        isFetched = true;
      });
    });
  } //fetchTypes

  @override
  void initState() {
    super.initState();

    fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course category"),
      ),
      body: isFetched
          ? Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      onTap: (){
                        if(index!=0)return;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseCategoryChooserScreen(
                                  id: widget.id,
                                  keys: categories,
                                  ),
                            ));
                        
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Card(
                        // color: index ==0 ? Colors.pink.shade600: null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: index!=0 ?Text(categories.elementAt(index)["title"]): Icon(Icons.add),
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
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //                   Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => CourseCategoryChooserScreen(
      //                             id: widget.id,
      //                             keys: categories,
      //                             ),
      //                       ));
      //   },
      // ),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  } //build
}//_TypeScreen