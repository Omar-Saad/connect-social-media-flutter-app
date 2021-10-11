import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/modules/comments/comments_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return ConditionalBuilder(
          condition: cubit.posts.length > 0 && cubit.userModel != null,
          builder: (context) => Column(
            children: [
              Expanded(
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(
                        postModel: cubit.posts[index],
                        context: context,
                        onCommentClicked: () {
                          navigate(
                              context,
                              CommentsScreen(
                                postModel: cubit.posts[index],
                              ));
                        }),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 8.0,
                        ),
                    itemCount: cubit.posts.length),
              ),
              SizedBox(
                height: 8.0,
              )
            ],
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
