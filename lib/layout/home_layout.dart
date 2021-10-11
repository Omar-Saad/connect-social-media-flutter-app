import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/cubit/states.dart';
import 'package:connect/modules/new_post/new_post_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(icon: Icon(IconBroken.Notification), onPressed: () {}),
              IconButton(icon: Icon(IconBroken.Search), onPressed: () {}),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              if (value == 2)
                navigate(context, NewPostScreen());
              else
                cubit.changeBottomNav(value);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home), label: 'Home',),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Plus), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Location), label: 'Users'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Profile), label: 'Profile')
            ],
          ),
        );
      },
    );
  }
}
