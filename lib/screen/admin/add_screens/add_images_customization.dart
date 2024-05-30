

import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBackgroundCustom extends StatefulWidget{

  dynamic data;
  AddBackgroundCustom({super.key,this.data});

  State<AddBackgroundCustom> createState()=> _AddTypeScreen();
}

class _AddTypeScreen extends State<AddBackgroundCustom>{
  String title="",imageURL="";
  int textColor=0,priority=0;
  int opacity = 0;

  DatabaseReference reference = FirebaseDatabase.instance.ref("/customization");
  final TextEditingController _textColorController = TextEditingController();
  final TextEditingController _opacityController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  

  void addTypes(){
    if(title.length <2 || imageURL.length <2) return; 
    reference.push().set(
      {
        "title":title,
        "imageURL":imageURL,
        "priority":priority,
        "textColor":textColor,
        "opacity":opacity,
      }
    ).then((value) {
      Navigator.pop(context);
    }).catchError((error){
      Navigator.pop(context);
      print("Error occured.$error");
    });
  }
  
  void editTypes(){
    if(_titleController.text.length <2 || _imageURLController.text.length <2) return; 
    // print(widget.data["key"]);
    reference.child(widget.data["key"]).update(
      {
        "title":_titleController.text,
        "imageURL":_imageURLController.text,
        "priority":int.parse(_priorityController.text),
        "textColor":int.parse(_textColorController.text),
        "opacity":int.parse(_opacityController.text),
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
    _textColorController.text = "0";
    _priorityController.text = "0";
    _opacityController.text = "0";
    if(widget.data == null) return;
    _textColorController.text = widget.data["textColor"].toString();
    _opacityController.text = widget.data["opacity"].toString();
    _imageURLController.text = widget.data["imageURL"];
    _priorityController.text = widget.data["priority"].toString();
    _titleController.text = widget.data["title"];

  }//initState

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Add Images"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                // minLines: 1,
                controller: _titleController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  labelText: 'title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
        
              TextField(
                minLines: 2,
                maxLines: 20,
                controller: _imageURLController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                onChanged: (value) => imageURL = value,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                // minLines: 1,
                controller: _priorityController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                onChanged: (value) => priority = int.parse(value),
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                // minLines: 1,
                controller: _textColorController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                onChanged: (value) => textColor = int.parse(value),
                decoration: InputDecoration(
                  labelText: 'textColor',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                // minLines: 1,
                controller: _opacityController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                onChanged: (value) => opacity = int.parse(value),
                decoration: InputDecoration(
                  labelText: 'Opacity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                padding: EdgeInsets.only(top: 18,bottom: 18),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: ()=>{
                  widget.data==null ? addTypes(): editTypes()
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                color: Colors.purple.shade700,
                elevation: 5.0,
                child: Text("Add Image",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }//
}