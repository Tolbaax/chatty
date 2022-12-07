class UserModel {
  String? name;
  String? phone;
  String? email;
  String? uID;
  bool? isEmailVerified;
  String? bio;
  String? header;
  String? image;
  UserModel({
    this.name,
    this.email,
    this.uID,
    this.phone,
    this.isEmailVerified,
    this.bio,
    this.header,
    this.image,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    uID = json['uId'];
    isEmailVerified = json['isEmailVerified'];
    bio = json['bio'];
    header = json['header'];
    image = json['image'];
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uID,
      'isEmailVerified': isEmailVerified,
      'bio': bio,
      'header': header,
      'image': image,
    };
  }
}
