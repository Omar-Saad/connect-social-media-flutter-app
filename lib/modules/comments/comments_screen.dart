import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/post_model.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/colors.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class CommentsScreen extends StatelessWidget {
  final PostModel postModel;
  var commentController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  FocusNode f1 = FocusNode();

  CommentsScreen({this.postModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(context: context, title: ''),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: GestureDetector(
                    child: Column(
                      children: [
                        buildPostItem(
                            postModel: postModel,
                            context: context,
                            onCommentClicked: () {
                              FocusScope.of(context).requestFocus(f1);
                            }),
                        SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comments',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 15.0),
                              ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    buildCommentItem(
                                        postModel.commentedUsers[index],
                                        context,
                                        index),
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 12.0,
                                ),
                                itemCount: postModel.commentedUsers.length,
                              ),
                              // buildCommentItem(postModel, context)
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      f1.unfocus();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    focusNode: f1,
                    minLines: 1,
                    maxLines: 20,
                    controller: commentController,
                    validator: (String value) {
                      if (value.isEmpty) return 'Comment can\'t be empty';
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Write a comment...',
                      prefixIcon: Icon(IconBroken.Chat),
                      suffixIcon: IconButton(
                        icon: Icon(IconBroken.Send),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            String formattedDate =
                                Jiffy(DateTime.now()).yMMMMEEEEdjm.toString();
                            cubit.commentOnPost(
                              postModel: postModel,
                              text: commentController.text,
                              dateTime: formattedDate,
                            );
                            commentController.text = '';
                            f1.unfocus();
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCommentItem(
      CommentedUserModel commentedUserModel, context, index) {
    var cubit = SocialCubit.get(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            commentedUserModel.profileImage,
          ),
          radius: 20.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentedUserModel.name,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                height: 1.3,
                                fontSize: 16.0,
                              ),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        if (commentedUserModel.isFamousUser)
                          Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16,
                          )
                      ],
                    ),
                    Text(
                      commentedUserModel.dateTime,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            height: 1.3,
                          ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      commentedUserModel.comment,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize:16.0,
                        fontWeight: FontWeight.normal,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: iLikeComment(commentedUserModel, cubit)
                              ? Colors.red
                              : Colors.grey,
                          size: 16.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: iLikeComment(commentedUserModel, cubit)
                                    ? Colors.red
                                    : Colors.black,
                              ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (!iLikeComment(postModel.commentedUsers[index], cubit))
                        cubit.commentLike(postModel, index);
                      else
                        cubit.unLikeComment(postModel, index);

                    },
                  ),
                  Spacer(),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 16.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${postModel.commentedUsers[index].commentLikers.length}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Likes',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            content: Container(
                              width: 300.0,
                              height: 300.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, item_index) => Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              commentedUserModel.commentLikers[item_index]
                                                  .profileImage,
                                            ),
                                            radius: 20.0,
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                commentedUserModel
                                                    .commentLikers[item_index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      height: 1.3,
                                                    ),
                                              ),
                                              SizedBox(
                                                width: 6.0,
                                              ),
                                              if (commentedUserModel.commentLikers[item_index]
                                                  .isFamousUser)
                                                Icon(
                                                  Icons.check_circle,
                                                  color: defaultColor,
                                                  size: 18,
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                itemCount: commentedUserModel.commentLikers.length,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool iLikeComment(CommentedUserModel comment, SocialCubit cubit) {
    return comment.commentLikers.any((element) {
      if (element.uId == cubit.userModel.uId) return true;
      return false;
    });
  }
}
