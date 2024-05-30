import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_images_customization.dart';
import 'package:loksewa/screen/admin/add_screens/add_type_screen.dart';
import 'package:loksewa/screen/admin/category_screen_admin.dart';
import 'package:loksewa/screen/admin/course_category_adder_screen.dart';
import 'package:loksewa/screen/admin/model_admin/dummy_data.dart';

class CustomizationMainPage extends StatefulWidget {
  CustomizationMainPage({super.key});
  @override
  State<CustomizationMainPage> createState() => _TypeScreen();
}

class _TypeScreen extends State<CustomizationMainPage> {

    List<dynamic> customActions = [];
    DatabaseReference database = FirebaseDatabase.instance.ref("/customization");
  

  void fetchBackgrounds(){
      database.orderByChild("priority").onValue.listen((event) {
        customActions = [];
      event.snapshot.children.forEach((element) {
        print(element.key);
        customActions.add(

      {
        "title":element.child("title").value,
        "imageURL":element.child("imageURL").value,
        "priority":element.child("priority").value as int,
        "textColor":element.child("textColor").value as int,
        "opacity":element.child("opacity").value as int,
        "key":element.key.toString(),
      }//add
        );
       });
       setState(() {
       }); 
      });//databse
  }//fetch


  @override
  void initState() {
    super.initState();
    fetchBackgrounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customization"),
      ),
      body: Container(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10),
              child: ListView.builder(
                itemCount: customActions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onLongPress: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return AddBackgroundCustom(data: customActions.elementAt(index),);
                          },
                        ));
                      },
                      child: Container(
                        height: 250,
                        // width: 300,
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 1),
                        borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            
                            // image: NetworkImage(customActions.elementAt(index)["imageURL"]),
                            image: CachedNetworkImageProvider(
                              customActions.elementAt(index)["imageURL"],
                            ),
                            fit: BoxFit.fill,
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Card(
                            color:  Color.fromARGB(customActions.elementAt(index)["opacity"], 0, 0, 0),
                            // color:index ==0? Colors.purple.shade700: null,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text( (index+1).toString()+". "+ customActions.elementAt(index)["title"],style: TextStyle(color:customActions.elementAt(index)["textColor"] ==0? Colors.white:Colors.black,),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddBackgroundCustom(),));
        },
      ),
    );
  } //build
}//_TypeScreen