class PostModel {
  String? name;
  String? uID;
  String? image;
  String? time;
  String? postText;
  String? postId;
  String? postImage;
  var likes;

  PostModel({
    this.name,
    this.uID,
    this.image,
    this.postText,
    this.postImage,
    this.postId,
    this.likes,
    this.time,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uID = json['uId'];
    image = json['image'];
    time = json['time'];
    postText = json['postText'];
    postImage = json['postImage'];
    postId = json['postId'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uId': uID,
      'image': image,
      'postText': postText,
      'postImage': postImage,
      'postId': postId,
      'time': time,
      'likes': likes,
    };
  }
}
