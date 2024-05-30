

// import 'package:loksewa/design_course/models/category.dart';
import 'package:loksewa/screen/courses/model/category.dart';
import 'package:loksewa/screen/courses/categories/sub_category_screen.dart';

class Course{

  Course({required this.name,required this.imagePath,required this.categoriesMCQ});
  String name,imagePath;
  List<CategoryMCQ> categoriesMCQ;
}

class Category{
  Category({required this.title,required this.courses});
  String title;
  List<Course> courses;
}

List<Map<String,dynamic>> datas = [
  {
    "title":"Prasasan",
    "courses":[
      {
        "id": 1,
        "title":"Sakha Adhikirit",
        "imagePath": "assets/design_course/interFace1.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
      {
        "id": 2,
        "title":"Nayab Subbha",
        "imagePath": "assets/design_course/interFace2.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
      {
        "id": 3,
        "title":"Khariddar",
        "imagePath": "assets/design_course/interFace3.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
    ]//courses list
  },//prasansan
 {
    "title":"Civil Engineering",
    "courses":[
      {
        "id": 4,
        "title":"Civil Engineer",
        "imagePath": "assets/design_course/interFace4.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
      {
        "id": 5,
        "title":"Sub-Engineer",
        "imagePath": "assets/design_course/interFace2.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
      {
        "id": 6,
        "title":"As. Sub Er",
        "imagePath": "assets/design_course/interFace3.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
    ]//courses list
  },//civil engineer
 {
    "title":"Nepal Prahari",
    "courses":[
      {
        "id": 7,
        "title":"Inspector",
        "imagePath": "assets/design_course/interFace2.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
      {
        "id": 8,
        "title":"As. SUb-Inspector",
        "imagePath": "assets/design_course/interFace1.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
    ]//courses list
  },//Nepal Prahari
 {
    "title":"Nepali Sena",
    "courses":[
      {
        "id": 9,
        "title":"Officer Cadet",
        "imagePath": "assets/design_course/interFace2.png",
        "categoriesMCQId":[1,2,3,4,5,6,7,8],
        "syallbus":"main.pdf",
        "history":{},
      },//courses
    ]//courses list
  },//civil engineer
  ];

Map<int,dynamic> subCategoryMCQ = { 1:{
      "id":1,
      "title":"Vaugolic xetra",
      "image":"assets/design_course/interFace2.png"
    },
    2:{
      "id":2,
      "title":"Kiritman",
      "image":"assets/design_course/interFace1.png"
    },
    3:{
      "id":3,
      "title":"Dharatliye bibhajan",
      "image":"assets/design_course/interFace3.png"
    },
    4:{
      "id":4,
      "title":"Himsrinkhala tatha himaalharu",
      "image":"assets/design_course/interFace4.png"
    },
    5:{
      "id":5,
      "title":"Prasisdha sthanharu",
      "image":"assets/design_course/interFace1.png"
    },
    6:{
      "id":6,
      "title":"Jalsampada",
      "image":"assets/design_course/interFace3.png"
    },
    7:{
      "id":7,
      "title":"Bhu sampada",
      "image":"assets/design_course/interFace1.png"
    },
    8:{
      "id":8,
      "title":"Kahnij sampadha",
      "image":"assets/design_course/interFace4.png"
    },
};


Map<int,dynamic> myData ={ 
  1:{
    "id":1,
    "title":"Nepalko bhugol",
    "image":"assets/design_course/interFace1.png",
    "path":"gk subj-02 I",
    "subCategoriesId":subCategoryMCQ
  },//1
  2:{
    "id":2,
    "title":"Bramandha sambhandi janakari",
    "image":"assets/design_course/interFace1.png",
    "path":"gk subj-01 I",
    "subCategoriesId":subCategoryMCQ
  },//1

};

Map<int,dynamic> categoriesMCQ ={
  1:{
    "id":1,
    "title":"Nepalko bhugol",
    "image":"assets/design_course/interFace1.png",
    "path":"gk subj-02 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  2:{
    "id":2,
    "title":"Bramandha sambhandi janakari",
    "image":"assets/design_course/interFace2.png",
    "path":"gk subj-01 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  3:{
    "id":3,
    "title":"Bissoko bhugol",
    "image":"assets/design_course/interFace3.png",
    "path":"gk subj-03 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  4:{
    "id":4,
    "title":"Nepal ko itihash",
    "image":"assets/design_course/interFace1.png",
    "path":"gk subj-05 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  5:{
    "id":5,
    "title":"Bisso ko itihash",
    "image":"assets/design_course/interFace2.png",
    "path":"gk subj-04 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  6:{
    "id":6,
    "title":"Nepalko samajik yawo sankiritk awastha",
    "image":"assets/design_course/interFace3.png",
    "path":"gk subj-06 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  7:{
    "id":7,
    "title":"Nepalko arthik awastha",
    "image":"assets/design_course/interFace4.png",
    "path":"gk subj-08 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
  8:{
    "id":8,
    "title":"Bigyan ra prabidhi",
    "image":"assets/design_course/interFace2.png",
    "path":"gk subj-09 I",
    "subCategoriesId":[1,2,3,4,5,6,7,8]
  },//1
}; 

Map<int,dynamic> subCategoryMCQ2 = { 1:{
      "id":1,
      "title":"Vaugolic xetra",
      "image":"assets/design_course/interFace2.png"
    },
    2:{
      "id":2,
      "title":"Kiritman",
      "image":"assets/design_course/interFace1.png"
    },
    3:{
      "id":3,
      "title":"Dharatliye bibhajan",
      "image":"assets/design_course/interFace3.png"
    },
    4:{
      "id":4,
      "title":"Himsrinkhala tatha himaalharu",
      "image":"assets/design_course/interFace4.png"
    },
    5:{
      "id":5,
      "title":"Prasisdha sthanharu",
      "image":"assets/design_course/interFace1.png"
    },
    6:{
      "id":6,
      "title":"Jalsampada",
      "image":"assets/design_course/interFace3.png"
    },
    7:{
      "id":7,
      "title":"Bhu sampada",
      "image":"assets/design_course/interFace1.png"
    },
    8:{
      "id":8,
      "title":"Kahnij sampadha",
      "image":"assets/design_course/interFace4.png"
    },
};


