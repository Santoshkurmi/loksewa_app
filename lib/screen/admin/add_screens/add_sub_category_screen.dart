import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddSubCategoryScreen extends StatefulWidget {
  String parentKey;
  dynamic data;
  AddSubCategoryScreen({super.key,required this.parentKey,this.data});
  State<AddSubCategoryScreen> createState() => _AddSubCategoryScreen();
}

class _AddSubCategoryScreen extends State<AddSubCategoryScreen> {
  String title = "", path = "";
  bool isLoading = false;
  int id = 0;
  DatabaseReference reference = FirebaseDatabase.instance.ref("/categories");
  TextEditingController _titleController = TextEditingController();

  void addCategory(String parentKey) {
    if (_titleController.text.length < 2) return;
    setState((){
      isLoading = true;
    });
    reference.child(parentKey).child("subCategories").push().set({
      // "id": id,
      "title": _titleController.text,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      print("Error occured.$error");
    });
  }

  void editCategory(String parentKey) {
    if (_titleController.text.length < 2) return;
    setState((){
      isLoading = true;
    });

    reference.child(parentKey).child("subCategories").child(widget.data["key"]).update({
      // "id": id,
      "title": _titleController.text,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      print("Error occured.$error");
    });
  }
  

  @override
  void initState() {
    super.initState();
    if(widget.data==null) return;
    _titleController.text = widget.data["title"];
  }

  @override
  Widget build(BuildContext context) {
    String parentKey = widget.parentKey;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add SubCategory"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // TextField(
              //   // minLines: 1,
              //   cursorColor: Colors.black,
              //   keyboardType: TextInputType.number,
              //   onChanged: (value) => id = value as int,
              //   decoration: InputDecoration(
              //     labelText: 'id',
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     prefixIcon: Icon(Icons.title),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              TextField(
                // minLines: 1,
                controller: _titleController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // TextField(
              //   // minLines: 1,
              //   cursorColor: Colors.black,
              //   keyboardType: TextInputType.emailAddress,
              //   onChanged: (value) => path = value,
              //   decoration: InputDecoration(
              //     labelText: 'path',
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     prefixIcon: Icon(Icons.title),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
             isLoading?Center(child: CircularProgressIndicator(),): MaterialButton(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () => {widget.data==null? addCategory(parentKey):editCategory(parentKey)},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                color: Colors.purple.shade700,
                elevation: 5.0,
                child: Text(
                  "Add Category",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } //
}
