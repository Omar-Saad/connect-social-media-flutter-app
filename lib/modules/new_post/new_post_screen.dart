import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

class NewPostScreen extends StatelessWidget {
  var postController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state)
      {
        if(state is SocialCreatePostSuccessState)
          {
            SocialCubit.get(context).resetPostFields();
            Navigator.pop(context);
          }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var userModel = cubit.userModel;

        return Scaffold(
          appBar: AppBar(
            title: Text('New Post'),
            leading: IconButton(icon: Icon(Icons.close),
              onPressed: (){
                Navigator.of(context).pop();
              },),
            actions: [
              TextButton(
                  onPressed: () {
                    if(postController.text.isNotEmpty||cubit.postImage!=null) {

                      cubit.uploadPost(postText: postController.text,
                          dateTime: DateTime.now().toString());
                    }
                    else{
                      formKey.currentState.validate();
                    }
                    },
                  child: Text(
                    'POST',
                  )),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if(state is SocialCreatePostLoadingState)
                      LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
              SizedBox(height: 10.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(userModel.profileImage),
                          radius: 25.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          userModel.name,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                height: 1.3,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) return 'Post Can\'t be empty';
                        return null;
                      },
                      controller: postController,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            letterSpacing: 0.8,
                          ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText:
                            'What is on your mind, ${userModel.name.split(' ')[0]}? ',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    if(cubit.postImage!=null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              4.0,
                            ),
                            image: DecorationImage(
                              image: FileImage(cubit.postImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              cubit.pickPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconBroken.Image,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     child: Text(
                        //       '# tags',
                        //       style: TextStyle(
                        //         fontSize: 16.0,
                        //         letterSpacing: 0.8,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
