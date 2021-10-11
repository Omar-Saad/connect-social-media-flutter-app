class UserModel {
  String name;
  String email;
  String phone;
  String uId;
  String profileImage;
  String coverImage;
  String bio;
  bool isFamousUser;
  bool isEmailVertified;

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.uId,
      this.isEmailVertified,
      this.profileImage,
        this.isFamousUser,
      this.coverImage,this.bio});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    isFamousUser = json['isFamousUser'];
    isEmailVertified = json['isEmailVertified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
      'isFamousUser': isFamousUser,
      'isEmailVertified': isEmailVertified,
    };
  }
}
