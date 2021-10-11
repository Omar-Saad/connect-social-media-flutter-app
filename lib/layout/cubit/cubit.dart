import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/message_model.dart';
import 'package:connect/models/post_model.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/modules/chats/chats_screen.dart';
import 'package:connect/modules/feeds/feeds_screen.dart';
import 'package:connect/modules/new_post/new_post_screen.dart';
import 'package:connect/modules/profile/profile_screen.dart';
import 'package:connect/modules/users_nearby/users_nearby_screen.dart';
import 'package:connect/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:jiffy/jiffy.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel userModel;

  ImagePicker picker = ImagePicker();

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersNearByScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'New Post',
    'Users',
    'Profile',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  Future<XFile> pickImage() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }

//update user data
  File profileImage;
  File coverImage;

  void pickProfileImage() async {
    pickImage().then((value) {
      profileImage = File(value.path);
      emit(SocialProfileImagePickedSuccessState());
    }).catchError((error) {
      print('No image selected ');
      emit(SocialProfileImagePickedErrorState(error.toString()));
    });
  }

  void pickCoverImage() async {
    pickImage().then((value) {
      coverImage = File(value.path);
      emit(SocialCoverImagePickedSuccessState());
    }).catchError((error) {
      print('No image selected ');
      emit(SocialCoverImagePickedErrorState(error.toString()));
    });
  }

  Future<String> uploadProfileImage() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${userModel.uId}/profile_image')
        .putFile(profileImage)
        .then((value) async {
      return await value.ref.getDownloadURL();
    });
  }

  Future<String> uploadCoverImage() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${userModel.uId}/cover_image')
        .putFile(coverImage)
        .then((value) async {
      return await value.ref.getDownloadURL();
    });
  }

  uploadUpdatedUser({
    @required String name,
    @required String phone,
    @required String bio,
  }) async {
    emit(SocialUpdateUserLoadingState());

    if (profileImage != null || coverImage != null) {
      String profileImageUrl;
      String coverImageUrl;

      if (profileImage != null) {
        uploadProfileImage().then((value) {
          profileImageUrl = value;
          if (coverImage != null){
            uploadCoverImage().then((value) {
              coverImageUrl = value;
              updateUser(
                  name: name,
                  phone: phone,
                  bio: bio,
                  profileImage: profileImageUrl,
                  coverImage: coverImageUrl);
            }).catchError((error) {
              emit(SocialUploadCoverImageErrorState(error.toString()));
            }).catchError((error) {
              print(error.toString());
              emit(SocialUploadProfileImageErrorState(error.toString()));
              });}
          else
            {
              updateUser(
                  name: name, phone: phone, bio: bio, profileImage: profileImageUrl);
            }
        });
      } else {
        uploadCoverImage().then((value) {
          coverImageUrl = value;
          updateUser(
              name: name, phone: phone, bio: bio, coverImage: coverImageUrl);
        }).catchError((error) {
          emit(SocialUploadCoverImageErrorState(error.toString()));
        });
      }
    } else {
      updateUser(name: name, phone: phone, bio: bio);
    }
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String profileImage,
    String coverImage,
  }) {
    emit(SocialUpdateUserLoadingState());

    userModel.name = name;
    userModel.phone = phone;
    userModel.bio = bio;

    if (profileImage != null) userModel.profileImage = profileImage;

    if (coverImage != null) userModel.coverImage = coverImage;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(userModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState(error.toString()));
    });
  }

  void resetNotUpdatedFields() {
    profileImage = null;
    coverImage = null;
    emit(SocialResetNotUpdatedFieldsState());
  }

  //create post

  File postImage;

  void pickPostImage() async {
    pickImage().then((value) {
      postImage = File(value.path);
      emit(SocialPostImagePickedSuccessState());
    }).catchError((error) {
      emit(SocialPostImagePickedErrorState(error.toString()));
    });
  }

  Future<String> uploadPostImage() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${userModel.uId}/posts_images/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) async {
      // emit(SocialUploadPostImageSuccessState());

      return await value.ref.getDownloadURL();
    }).catchError((error) {
      emit(SocialUploadPostImageErrorState(error.toString()));
    });
  }

  void _createPost(
      {@required String postText,
      @required String dateTime,
      String postImage}) {
    //emit(SocialCreatePostLoadingState());

    PostModel postModel = PostModel(
        name: userModel.name,
        uId: userModel.uId,
        postText: postText,
        dateTime: dateTime,
        postImage: postImage,
        isFamousUser: userModel.isFamousUser,
        profileImage: userModel.profileImage);
    postModel.postId = userModel.uId + DateTime.now().toString();

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .set(postModel.toMap())
        .then((value) {
          posts.insert(0, postModel);

      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  void uploadPost({@required String postText, @required String dateTime}) {
    emit(SocialCreatePostLoadingState());

    if (postImage != null)
      uploadPostImage().then((value) {
        _createPost(postText: postText, postImage: value, dateTime: dateTime);
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    else
      _createPost(postText: postText, dateTime: dateTime);
  }

  void resetPostFields() {
    postImage = null;
    emit(SocialResetPostFieldsState());
  }

  //get posts

  List<PostModel> posts = [];

  void getPosts() {
    posts.clear();

    emit(SocialGetPostsLoadingState());

    //get post data
    FirebaseFirestore.instance.collection('posts')
        .orderBy('dateTime',descending: true)
        .snapshots().listen((value)   {
      posts.clear();
       value.docs.forEach((element) {
        PostModel model = PostModel.fromJson(element.data());

        Future.wait<void>(
            [
          //get likes of the post
        element.reference.collection('likes').get().then((value) {
          value.docs.forEach((user) {
            model.likedUsers.add(LikedUserModel.fromJson(user.data()));
          });
          //  emit(SocialGetLikePostSuccessState());
        }).catchError((error) {
          emit(SocialGetLikePostErrorState(error.toString()));
        }),
        //get comments of the post
        element.reference.collection('comments').get().then((value) {
        value.docs.forEach((commentedUser) {
        CommentedUserModel comment =
        CommentedUserModel.fromJson(commentedUser.data());
        //get likes of the comment
        commentedUser.reference
            .collection('commentLikes')
            .get()
            .then((value) {
        value.docs.forEach((user) {
        comment.commentLikers
            .add(LikedUserModel.fromJson(user.data()));
        });
        model.commentedUsers.add(comment);
        //   emit(SocialGetCommentsOnPostSuccessState());
        }).catchError((error) {
        emit(SocialGetCommentsOnPostErrorState(error.toString()));
        });
        });
        }).catchError((error) {
        emit(SocialGetCommentsOnPostErrorState(error.toString()));
        }),
        FirebaseFirestore.instance
            .collection('users')
            .doc(model.uId)
            .get()
            .then((value) {
        UserModel user = UserModel.fromJson(value.data());

        model.profileImage = user.profileImage;
        model.isFamousUser = user.isFamousUser;
        model.name = user.name;
   //     print('mooode  : ${model.name}');
        posts.add(model);
        }),

        ]
        ).then((value) {});
      });

      emit(SocialGetPostsSuccessState());

    }).onError((error) {
      print('${error.toString()}');
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  List<PostModel> myPosts = [];

  void getMyPosts() {
    myPosts.clear();
    posts.forEach((element) {
      if (element.uId == userModel.uId) myPosts.add(element);
    });
    emit(SocialGetMyPostsSuccessState());
  }

  void hidePost(PostModel postModel) {
    posts.remove(postModel);
    emit(SocialHidePostSuccessState());
  }

  //likes
  void likePost(PostModel postModel) {
    LikedUserModel likedUserModel = LikedUserModel(
        name: userModel.name,
        isFamousUser: userModel.isFamousUser,
        uId: userModel.uId,
        profileImage: userModel.profileImage);

    postModel.likedUsers.add(likedUserModel);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('likes')
        .doc(userModel.uId)
        .set(likedUserModel.toMap())
        .then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void unLikePost(PostModel postModel) {
    postModel.likedUsers.removeWhere((element) {
      if (element.uId == userModel.uId) return true;
      return false;
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('likes')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      emit(SocialUnLikePostSuccessState());
    }).catchError((error) {
      emit(SocialUnLikePostErrorState(error.toString()));
    });
  }

//comments

  void commentOnPost({PostModel postModel, String text, String dateTime}) {
    CommentedUserModel comment = CommentedUserModel(
        name: userModel.name,
        isFamousUser: userModel.isFamousUser,
        uId: userModel.uId,
        profileImage: userModel.profileImage,
        comment: text,
        dateTime: dateTime,
        commentId: userModel.uId + DateTime.now().toString());

    postModel.commentedUsers.add(comment);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('comments')
        .doc(comment.commentId)
        .set(comment.toMap())
        .then((value) {
      emit(SocialCommentOnPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentOnPostErrorState(error.toString()));
    });
  }

  void commentLike(PostModel postModel, index) {
    LikedUserModel liker = LikedUserModel(
      name: userModel.name,
      isFamousUser: userModel.isFamousUser,
      uId: userModel.uId,
      profileImage: userModel.profileImage,
    );

    postModel.commentedUsers[index].commentLikers.add(liker);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('comments')
        .doc(postModel.commentedUsers[index].commentId)
        .collection('commentLikes')
        .doc(userModel.uId)
        .set(liker.toMap())
        .then((value) {
      emit(SocialCommentLikeSuccessState());
    }).catchError((error) {
      emit(SocialCommentLikeErrorState(error.toString()));
    });
  }

  void unLikeComment(PostModel postModel, index) {
    postModel.commentedUsers[index].commentLikers.removeWhere((element) {
      if (element.uId == userModel.uId) return true;
      return false;
    });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postModel.postId)
        .collection('comments')
        .doc(postModel.commentedUsers[index].commentId)
        .collection('commentLikes')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      emit(SocialUnLikeCommentSuccessState());
    }).catchError((error) {
      emit(SocialUnLikeCommentErrorState(error.toString()));
    });
  }

  List<UserModel> allUsers = [];

  void getAllUsers() async {
    allUsers.clear();

    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel.uId)
          allUsers.add(UserModel.fromJson(element.data()));
      });
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  //chats

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String textMessage,
  }) {
    if (chatImage != null) {
      uploadChatImage(receiverId).then((value) {
        _uploadMessage(
            receiverId: receiverId,
            dateTime: dateTime,
            textMessage: textMessage,
            imageUrl: value);
      }).catchError((error) {
        emit(SocialSendMessageErrorState(error.toString()));
      });
    } else {
      _uploadMessage(
          receiverId: receiverId,
          dateTime: dateTime,
          textMessage: textMessage,
          imageUrl: null);
    }
  }

  void _uploadMessage({
    @required String receiverId,
    @required String dateTime,
    @required String textMessage,
    @required String imageUrl,
  }) {
    MessageModel messageModel = MessageModel(
        dateTime: dateTime,
        receiverId: receiverId,
        senderId: userModel.uId,
        textMessage: textMessage,
        image: imageUrl);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      chatImage = null;
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    }).onError((error) {
      emit(SocialGetMessagesErrorState(error.toString()));
    });
  }

  File chatImage;

  void pickChatImage() async {
    pickImage().then((value) {
      chatImage = File(value.path);
      emit(SocialChatImagePickedSuccessState());
    }).catchError((error) {
      emit(SocialChatImagePickedErrorState(error.toString()));
    });
  }

  Future<String> uploadChatImage(String receiverId) async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${userModel.uId}/chats_images/$receiverId/${Uri.file(chatImage.path).pathSegments.last}')
        .putFile(chatImage)
        .then((value) async {
      // emit(SocialUploadPostImageSuccessState());

      return await value.ref.getDownloadURL();
    }).catchError((error) {
      emit(SocialUploadChatImageErrorState(error.toString()));
    });
  }
}
