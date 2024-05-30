
class CategoryMCQ{
  int id;
  String title,imagePath,path;
  List<SubCategoryMCQ> subCategoryMCQ;
  CategoryMCQ({required this.id,required this.title,required this.imagePath,required this.path,required this.subCategoryMCQ});
}

class SubCategoryMCQ{
  
  int id;
  String title,imagePath;
  SubCategoryMCQ({required this.id,required this.title,required this.imagePath});
}


