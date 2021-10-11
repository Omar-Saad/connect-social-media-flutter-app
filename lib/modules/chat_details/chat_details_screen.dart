import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/message_model.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/modules/chat_details/pick_image_screen.dart';
import 'package:connect/modules/show_image/show_image_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/colors.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;
  var formKey = GlobalKey<FormState>();
  var messageController = TextEditingController();

  ChatDetailsScreen(this.userModel);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if(state is SocialChatImagePickedSuccessState)
              navigate(context, ChatPickImageScreen(userModel));
          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Row(children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      userModel.profileImage,
                    ),
                    radius: 20.0,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    userModel.name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          height: 1.3,
                        ),
                  ),
                ]),
                titleSpacing: 0.0,
              ),
              body: ConditionalBuilder(
                condition: true, //cubit.messages.length > 0,
                builder: (context) => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.separated(
                            reverse: true,
                            physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                MessageModel messageModel =
                                    cubit.messages[cubit.messages.length -index-1];
                                if (messageModel.receiverId == userModel.uId)
                                  return buildMessage(
                                      messageModel: messageModel,
                                      isMyMessage: true,context: context);
                                return buildMessage(
                                    messageModel: messageModel,
                                    isMyMessage: false,context: context);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 15.0,
                                  ),
                              itemCount: cubit.messages.length),
                        ),
                      ),
                      Container(
                        // height: 100.0,
                        //width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor('#F0F0F0'),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: IconButton(
                                  icon: Icon(
                                    IconBroken.Image,
                                    color: defaultColor,
                                  ),
                                  onPressed: () {
                                    cubit.pickChatImage();
                                  }),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return 'Message can\'t be empty';
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    focusColor: Colors.white,
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    hintText: 'Enter your message here...',
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 5.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: defaultColor,
                                  shape: BoxShape.circle,
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      cubit.sendMessage(
                                          receiverId: userModel.uId,
                                          dateTime: DateTime.now().toString(),
                                          textMessage: messageController.text);
                                      messageController.text = '';
                                    }
                                  },
                                  minWidth: 1.0,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(
          {@required MessageModel messageModel, @required bool isMyMessage,@required context}) =>
      Align(
        alignment: isMyMessage
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (messageModel.image != null)
                InkWell(
                  onTap: () {
                    navigate(context, ShowImageScreen(messageModel.image));
                  },
                  child: CachedNetworkImage(
                    imageUrl: messageModel.image,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fill,
                  ),
                ),
              if (messageModel.image != null)
                SizedBox(height: 5.0,),
                Text(
                messageModel.textMessage,
                maxLines: null,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: isMyMessage
                ? defaultColor.withOpacity(
                    0.2,
                  )
                : Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              bottomEnd: !isMyMessage
                  ? Radius.circular(
                      10.0,
                    )
                  : Radius.circular(
                      0.0,
                    ),
              bottomStart: !isMyMessage
                  ? Radius.circular(
                      0.0,
                    )
                  : Radius.circular(
                      10.0,
                    ),
            ),
          ),
        ),
      );
}
