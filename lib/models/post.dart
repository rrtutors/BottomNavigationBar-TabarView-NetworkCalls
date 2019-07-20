
class Post{
  String id;
  String language;
  String qtn_title;
  String ans_description;
  String created_on;

  Post(this.id,this.language,this.qtn_title,this.ans_description,this.created_on);

  static Post fromJson(Map <String,dynamic> map)
  {
    return Post(map['id'].toString(),map['language'],map['qtn_title'],map['ans_description'],map['created_on']);
  }
}