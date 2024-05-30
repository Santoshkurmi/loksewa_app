import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loksewa/screen/admin/add_screens/add_images_customization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUIBackground extends StatefulWidget {
  int id;
  ChangeUIBackground({super.key,required this.id});
  @override
  State<ChangeUIBackground> createState() => _TypeScreen();
}

class _TypeScreen extends State<ChangeUIBackground> {

    List<dynamic> customActions = [];
    DatabaseReference database = FirebaseDatabase.instance.ref("/customization");
  
   void saveState(int index) async {
    int type = widget.id;
    String keyName = "";
    switch(type){
      case 0:keyName = "qb";break;
      case 1:keyName = "qf";break;
      case 2:keyName = "hb";break;
      case 3:keyName = "cib";break;
      case 4:keyName = "cb";break;
      case 5:keyName = "scb";break;
      // case 5:keyName = "scb";break;

    }//swtich
    SharedPreferences preferences =await SharedPreferences.getInstance();
    await preferences.setStringList(keyName, [
      customActions.elementAt(index)["title"],
      customActions.elementAt(index)["imageURL"],
      customActions.elementAt(index)["priority"].toString(),
      customActions.elementAt(index)["textColor"].toString(),
      customActions.elementAt(index)["opacity"].toString(),
    ]);
    Navigator.pop(context);
  }

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
        title: Text("Choose background"),
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
                      onTap: () {
                          saveState(index);
                      },
                      child: Container(
                        height: 250,
                        // width: 300,
                        decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            
                            image: NetworkImage(customActions.elementAt(index)["imageURL"]),
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
                                  title: Text((index+1).toString()+". "+ customActions.elementAt(index)["title"],style: TextStyle(color:customActions.elementAt(index)["textColor"] ==0? Colors.white:Colors.black,),
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
    );
  } //build
}//_TypeScreen