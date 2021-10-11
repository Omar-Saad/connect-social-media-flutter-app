import 'package:connect/models/user_model.dart';

class PostModel {
  String postId;
  String uId;
  String name;
  String profileImage;
  String postText;
  String postImage;
  String dateTime;
  bool isFamousUser;
  List<LikedUserModel> likedUsers = [];
  List<CommentedUserModel> commentedUsers = [];


  PostModel(
      {
        this.postId,
        this.uId,
        this.name,
        this.profileImage,
        this.postText,
        this.postImage,
        this.dateTime,
        this.isFamousUser,
       });

  PostModel.fromJson(Map<String, dynamic> json) {

    postId = json['postId'];
    uId = json['uId'];
    // name = json['name'];
    // profileImage = json['profileImage'];
    postText = json['postText'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];


    // if(json['likedUsers']!=null)
    //   {
    //     print('liked not null ');
    //   json['likedUsers'].forEach((element){
    //     likedUsers.add(element);
    //   });
    //   }
    // print('liked   ');
    //



    //TODO POST TAGS
   // postTags = json['postTags'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uId': uId,
      // 'name': name,
      // 'profileImage': profileImage,
      'postText': postText,
      'postImage': postImage,
      'dateTime': dateTime,
      // 'postTags': postTags,
    };
  }

}

class LikedUserModel {
  String name;
  String uId;
  String profileImage;
  bool isFamousUser;

  LikedUserModel(
      {this.name,
        this.uId,
        this.profileImage,
        this.isFamousUser,
       });

  LikedUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    uId = json['uId'];
    profileImage = json['profileImage'];
    isFamousUser = json['isFamousUser'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'profileImage': profileImage,
      'isFamousUser': isFamousUser,
    };
  }
}

class CommentedUserModel {
  String name;
  String uId;
  String commentId;
  String profileImage;
  bool isFamousUser;
  String comment;
  String dateTime;
  List<LikedUserModel> commentLikers =[];

  CommentedUserModel(
      {this.name,
        this.uId,
        this.profileImage,
        this.isFamousUser,
        this.comment,
        this.dateTime,
        this.commentId,
      });

  CommentedUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];

    uId = json['uId'];
    profileImage = json['profileImage'];
    isFamousUser = json['isFamousUser'];
    comment = json['comment'];
    dateTime = json['dateTime'];

    commentId = json['commentId'];


  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'profileImage': profileImage,
      'isFamousUser': isFamousUser,
      'comment': comment,
      'dateTime': dateTime,
      'commentId': commentId,

    };
  }
}

