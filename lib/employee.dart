class employee{
  int id;
  String name;

  employee({this.name, this.id});

Map<String,dynamic>toMap(){
   var map=<String,dynamic>{
     'id':id,
     'name':name,
   };return map;
}
employee.fromMap(Map<String,dynamic>map){
  id=map['id'];
  name=map['name'];

}
}
