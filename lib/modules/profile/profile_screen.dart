import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/modules/comments/comments_screen.dart';
import 'package:connect/modules/edit_profile/edit_profile_screen.dart';
import 'package:connect/modules/new_post/new_post_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMyPosts();
        
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            UserModel model = cubit.userModel;

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Container(
                              width: double.infinity,
                              height: 140.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0)),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(model.coverImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                model.profileImage,
                              ),
                              radius: 60.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      model.bio,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '${cubit.myPosts.length}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Posts',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '30',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Photos',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '10K',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Followers',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Column(
                                children: [
                                  Text(
                                    '500',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    'Following',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              navigate(context, NewPostScreen());
                            },
                            child: Text('Add Post'),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            navigate(context, EditProfileScreen());
                          },
                          child: Icon(
                            IconBroken.Edit,
                            size: 18.0,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 15.0,
                        bottom: 8.0,
                        start: 8.0,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'My Posts',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),

                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildPostItem(
                            postModel: cubit.myPosts[index],
                            context: context,
                            onCommentClicked: () {
                              navigate(
                                  context,
                                  CommentsScreen(
                                    postModel: cubit.myPosts[index],
                                  ));
                            }),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 8.0,
                        ),
                        itemCount: cubit.myPosts.length),
                    SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
     
    );
  }
}
