import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  dynamic data;
  String type;
  AddCategoryScreen({super.key,this.data,required this.type});
  State<AddCategoryScreen> createState() => _AddCategoryScreen();
}

class _AddCategoryScreen extends State<AddCategoryScreen> {
  String title = "", path = "";
  bool isLoading = false;
  int id = 0;
  DatabaseReference reference = FirebaseDatabase.instance.ref("/");
  final TextEditingController _titleController = TextEditingController();

  void addCategory(String type) {
    if (title.length < 2) return;
    setState((){
      isLoading = true;
    });
    reference.child("categories").push().set({
      // "id": id,
      "title": title,
      "path": reference.child("/").push().key,
      "type":type,
      "subCategories":[],
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
    });
  }
  
  void editCategory() {
    if (_titleController.text.length < 2) return;
    setState((){
      isLoading = true;
    });
    reference.child("categories").child(widget.data["key"]).update({
      "title": _titleController.text,
    }).then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.data ==null) return;
    _titleController.text = widget.data["title"];
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
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
                cursorColor: Colors.black,
                controller: _titleController,
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
            isLoading? Center(child: CircularProgressIndicator(),):  MaterialButton(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () => { widget.data ==null ? addCategory(type):editCategory()},
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
