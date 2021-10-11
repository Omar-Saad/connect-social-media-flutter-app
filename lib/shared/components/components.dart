import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/models/post_model.dart';
import 'package:connect/modules/comments/comments_screen.dart';
import 'package:connect/modules/show_image/show_image_screen.dart';
import 'package:connect/shared/style/colors.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

void navigate(context, widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

Widget defaultTextFormField({
  @required controller,
  @required Function validator,
  @required TextInputType keyboardType,
  @required String label,
  @required IconData prefixIcon,
  IconData suffixIcon,
  Function onSuffixIconPressed,
  double radius = 8.0,
  Function onFieldSubmitted,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Colors.grey,width: 2.0,
          ),
        ),
      ),
    );

Widget defaultButton({
  @required String text,
  @required Function onPressed,
  double width = double.infinity,
  double height = 40.0,
  double radius = 8.0,
}) =>
    Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ),
    );

Widget defaultAppBar({
   @required String title,
  @required BuildContext context,
  List<Widget> actions,
})=> AppBar(

  title: Text(title),
  titleSpacing: 5.0,

  leading: IconButton(icon: Icon(IconBroken.Arrow___Left_2),
    onPressed: (){
      Navigator.of(context).pop();
    },),

  actions:actions,
);

Widget buildPostItem({
    @required PostModel postModel,
  @required context,
  @required Function onCommentClicked,
}) {
  var cubit = SocialCubit.get(context);
  return Card(
    elevation: 5.0,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    margin: EdgeInsets.symmetric(
      horizontal: 5.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  postModel.profileImage,
                ),
                radius: 25.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postModel.name,
                          style:
                          Theme.of(context).textTheme.bodyText1.copyWith(
                            height: 1.3,
                          ),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                          if(postModel.isFamousUser)
                        Icon(
                          Icons.check_circle,
                          color: defaultColor,
                          size: 18,
                        )
                      ],
                    ),
                    Text(
                      Jiffy(postModel.dateTime).yMMMMEEEEdjm.toString(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  IconBroken.More_Circle,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showModalBottomSheet(context: context,
                      builder: (context) => InkWell(
                        child: Container(
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0,),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(IconBroken.Hide,),
                              SizedBox(width: 15.0,),
                              Text('Hide',style: Theme.of(context).textTheme.bodyText1,),
                            ],
                          ),
                        ),
                        onTap: () {

                          cubit.hidePost(postModel);
                          Navigator.pop(context);

                        },
                      ),
                    useRootNavigator: true,
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Text(
            postModel.postText,
            style: Theme.of(context).textTheme.subtitle1,
          ),


          if (postModel.postImage != null)
            InkWell(
              onTap: () {
                navigate(context, ShowImageScreen(postModel.postImage));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        postModel.postImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: InkWell(
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
                            '${postModel.likedUsers.length}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text('Likes',style: Theme.of(context).textTheme.bodyText1,),
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            content: Container(
                              width: 300.0,
                              height: 300.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: CachedNetworkImageProvider(
                                              postModel.likedUsers[index].profileImage,
                                            ),
                                            radius: 20.0,
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                postModel.likedUsers[index].name,
                                                style:
                                                Theme.of(context).textTheme.bodyText1.copyWith(
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6.0,
                                              ),
                                              if(postModel.likedUsers[index].isFamousUser)
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
                                itemCount: postModel.likedUsers.length,),
                            ),

                          );
                        },);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 16.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${postModel.commentedUsers.length} comment',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: onCommentClicked,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          SocialCubit.get(context).userModel.profileImage,
                        ),
                        radius: 18.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Write a comment ...',
                        style: Theme.of(context).textTheme.caption.copyWith(
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  onTap: onCommentClicked,
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      color: iLikePost(postModel, cubit)
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
                        color: iLikePost(postModel, cubit) ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (!iLikePost(postModel, cubit))
                    cubit.likePost(postModel);
                  else
                    cubit.unLikePost(postModel);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

bool iLikePost(PostModel postModel, cubit) {
  return postModel.likedUsers.any((element) {
    if (element.uId == cubit.userModel.uId) return true;
    return false;
  });
}



void showToast({
  @required String message,
  @required ToastStates toastState,
}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16.0,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: chooseToastColor(toastState),
  );
}

Color chooseToastColor(ToastStates toastState){
  Color color = Colors.grey;
  switch(toastState)
  {
    case ToastStates.SUCCESS :
      color = Colors.green;
      break;
    case ToastStates.WARNING :
      color = Colors.yellow;
      break;
    case ToastStates.ERROR :
      color = Colors.red;
      break;
  }

  return color;

}

enum ToastStates { SUCCESS, ERROR, WARNING }
