import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/models/user_model.dart';
import 'package:connect/modules/chat_details/chat_details_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        SocialCubit.get(context).getAllUsers();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return ConditionalBuilder(
              condition: cubit.allUsers.length > 0,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildChatItem(context, cubit.allUsers[index]),
                  separatorBuilder: (context, index) => Container(
                    margin: const EdgeInsetsDirectional.only(start: 20.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  itemCount: cubit.allUsers.length),
              fallback: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      buildShimmerLoadingItem(),
                  separatorBuilder: (context, index) => Container(
                    margin: const EdgeInsetsDirectional.only(start: 20.0),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  itemCount: 10) ,
            );
          },

        );
      },
    );
  }

  Widget buildChatItem(context, UserModel userModel) => InkWell(
    child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                userModel.profileImage,
              ),
              radius: 25.0,
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
        ),
    onTap: () {
      navigate(context, ChatDetailsScreen(userModel));
    },
  );

  Widget buildShimmerLoadingItem()=>Padding(
    padding: const EdgeInsets.all(20.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[300],
      child: Row(
          children: [
        CircleAvatar(
          radius: 25.0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Container(
          color: Colors.grey,
          width: 150.0,
          height: 10.0,
        ),
      ]),
    ),
  );

}
