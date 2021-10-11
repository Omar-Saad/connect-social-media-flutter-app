import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state)
      {
        if(state is SocialGetUserSuccessState)
          Navigator.pop(context);
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        UserModel userModel = cubit.userModel;

        nameController.text = userModel.name;
        bioController.text = userModel.bio;
        phoneController.text = userModel.phone;

        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
            titleSpacing: 5.0,
            leading: IconButton(icon: Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
                cubit.resetNotUpdatedFields();
              },),
            actions: [
              TextButton(
                onPressed: () {
                  if(formKey.currentState.validate()) {
                    cubit.uploadUpdatedUser(name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  }
                },
                child: Text('UPDATE'),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: cubit.userModel!=null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is SocialUpdateUserLoadingState)
                        LinearProgressIndicator(),
                      if(state is SocialUpdateUserLoadingState)
                        SizedBox(height: 10.0,),
                      Container(
                        height: 190.0,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0)),
                                      image: DecorationImage(
                                        image: coverImage == null
                                            ? CachedNetworkImageProvider(
                                          userModel.coverImage,
                                        )
                                            : FileImage(coverImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: CircleAvatar(
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 18.0,
                                      ),

                                      radius: 20.0,
                                    ),
                                    onPressed: () {
                                      cubit.pickCoverImage();
                                    },
                                  ),
                                ],
                              ),
                              alignment: AlignmentDirectional.topCenter,
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 64.0,
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    backgroundImage: profileImage == null
                                        ? CachedNetworkImageProvider(
                                      userModel.profileImage,
                                    )
                                        : FileImage(profileImage),
                                    radius: 60.0,
                                  ),
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 18.0,
                                    ),
                                    radius: 20.0,
                                  ),
                                  onPressed: () {
                                    //open image picker
                                    cubit.pickProfileImage();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                          controller: nameController,
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Name must not be empty';
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          label: 'Name',
                          prefixIcon: IconBroken.User),
                      SizedBox(height: 10.0,),
                      defaultTextFormField(
                          controller: bioController,
                          validator: (String value) {
                            //Bio is not required
                          },
                          keyboardType: TextInputType.text,
                          label: 'Bio',
                          prefixIcon: IconBroken.Info_Circle),
                      SizedBox(height: 10.0,),
                      defaultTextFormField(
                          controller: phoneController,
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Phone must not be empty';
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          label: 'Phone',
                          prefixIcon: IconBroken.Call),
                    ],
                  ),
                ),
              ),
            ),
            fallback:(context) =>  Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
