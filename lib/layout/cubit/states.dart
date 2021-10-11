import 'package:connect/models/post_model.dart';

abstract class SocialStates {}

class SocialInitialState extends SocialStates{}


class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{

  SocialGetUserSuccessState();
}
class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);
}

//UPDATE USER STATES
class SocialProfileImagePickedSuccessState extends SocialStates{}
class SocialProfileImagePickedErrorState extends SocialStates{
  final String error;

  SocialProfileImagePickedErrorState(this.error);
}
class SocialCoverImagePickedSuccessState extends SocialStates{}
class SocialCoverImagePickedErrorState extends SocialStates{
  final String error;

  SocialCoverImagePickedErrorState(this.error);
}

class SocialUploadProfileImageSuccessState extends SocialStates{}
class SocialUploadProfileImageErrorState extends SocialStates{
  final String error;

  SocialUploadProfileImageErrorState(this.error);
}

class SocialUploadCoverImageSuccessState extends SocialStates{}
class SocialUploadCoverImageErrorState extends SocialStates{
  final String error;

  SocialUploadCoverImageErrorState(this.error);
}

class SocialUpdateUserLoadingState extends SocialStates{}

class SocialUpdateUserErrorState extends SocialStates{
  final String error;

  SocialUpdateUserErrorState(this.error);
}

class SocialResetNotUpdatedFieldsState extends SocialStates{}

//CREATE NEW POST STATES

class SocialPostImagePickedSuccessState extends SocialStates{}
class SocialPostImagePickedErrorState extends SocialStates{
  final String error;

  SocialPostImagePickedErrorState(this.error);
}

class SocialUploadPostImageSuccessState extends SocialStates{}
class SocialUploadPostImageErrorState extends SocialStates{
  final String error;

  SocialUploadPostImageErrorState(this.error);
}



class SocialCreatePostLoadingState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{
  final String error;

  SocialCreatePostErrorState(this.error);
}

class SocialResetPostFieldsState extends SocialStates{}

//Get Posts

class SocialGetPostsLoadingState extends SocialStates{}
class SocialGetPostsSuccessState extends SocialStates{}
class SocialGetPostsErrorState extends SocialStates{
  final String error;

  SocialGetPostsErrorState(this.error);
}
class SocialGetMyPostsSuccessState extends SocialStates{}

class SocialHidePostSuccessState extends SocialStates{}

class SocialGetLikePostSuccessState extends SocialStates{}
class SocialGetLikePostErrorState extends SocialStates{
  final String error;

  SocialGetLikePostErrorState(this.error);
}
class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final String error;

  SocialLikePostErrorState(this.error);
}

class SocialUnLikePostSuccessState extends SocialStates{}
class SocialUnLikePostErrorState extends SocialStates{
  final String error;

  SocialUnLikePostErrorState(this.error);
}

class SocialGetCommentsOnPostSuccessState extends SocialStates{}
class SocialGetCommentsOnPostErrorState extends SocialStates{
  final String error;

  SocialGetCommentsOnPostErrorState(this.error);
}

class SocialCommentOnPostSuccessState extends SocialStates{}
class SocialCommentOnPostErrorState extends SocialStates{
  final String error;

  SocialCommentOnPostErrorState(this.error);
}
class SocialCommentLikeSuccessState extends SocialStates{}
class SocialCommentLikeErrorState extends SocialStates{
  final String error;

  SocialCommentLikeErrorState(this.error);
}


class SocialUnLikeCommentSuccessState extends SocialStates{}
class SocialUnLikeCommentErrorState extends SocialStates{
  final String error;

  SocialUnLikeCommentErrorState(this.error);
}

class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  final String error;

  SocialGetAllUsersErrorState(this.error);
}

//chats
class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{
  final String error;

  SocialSendMessageErrorState(this.error);
}

class SocialGetMessagesSuccessState extends SocialStates{}
class SocialGetMessagesErrorState extends SocialStates{
  final String error;

  SocialGetMessagesErrorState(this.error);
}

class SocialChatImagePickedSuccessState extends SocialStates{}
class SocialChatImagePickedErrorState extends SocialStates{
  final String error;

  SocialChatImagePickedErrorState(this.error);
}

class SocialUploadChatImageSuccessState extends SocialStates{}
class SocialUploadChatImageErrorState extends SocialStates{
  final String error;

  SocialUploadChatImageErrorState(this.error);
}




class ChangeBottomNavState extends SocialStates {}


