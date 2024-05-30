

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddTypeScreen extends StatefulWidget{

  dynamic data;
  AddTypeScreen({super.key,this.data});

  State<AddTypeScreen> createState()=> _AddTypeScreen();
}

class _AddTypeScreen extends State<AddTypeScreen>{
  String title="",type="";
  bool isLoading = false;
  DatabaseReference reference = FirebaseDatabase.instance.ref("/types");
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _shortController = TextEditingController();
  

  void addTypes(){
    if(title.length <2 || type.length <2) return; 
    setState((){
      isLoading = true;
    });
    reference.push().set(
      {
        "title":title,
        "type":type,
      }
    ).then((value) {
      Navigator.pop(context);
    }).catchError((error){
      Navigator.pop(context);
      print("Error occured.$error");
    });
  }
  
  void editTypes(){
    if(_titleController.text.length <2 || _shortController.text.length <2) return; 
    setState((){
      isLoading = true;
    });
    reference.child(widget.data["key"]).update(
      {
        "title":_titleController.text,
        "type":_shortController.text,
      }
    ).then((value) {
      Navigator.pop(context);
    }).catchError((error){
      Navigator.pop(context);
      print("Error occured.$error");
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.data == null) return;
    _titleController.text = widget.data["title"];
    _shortController.text = widget.data["type"];

  }//initState

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Add types"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                // minLines: 1,
                controller: _titleController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
        
              TextField(
                // minLines: 1,
                controller: _shortController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => type = value,
                decoration: InputDecoration(
                  labelText: 'short type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
              isLoading? Center(child:CircularProgressIndicator() ):MaterialButton(
                padding: EdgeInsets.only(top: 18,bottom: 18),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: ()=>{
                  widget.data==null ? addTypes(): editTypes()
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                color: Colors.purple.shade700,
                elevation: 5.0,
                child: Text("Add types",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }//
}