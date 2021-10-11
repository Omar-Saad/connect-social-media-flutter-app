import 'package:bloc/bloc.dart';
import 'package:connect/bloc_observer.dart';
import 'package:connect/layout/cubit/cubit.dart';
import 'package:connect/layout/home_layout.dart';
import 'package:connect/modules/login/login_screen.dart';
import 'package:connect/modules/on_boadring/on_boarding_screen.dart';
import 'package:connect/shared/constants/constants.dart';
import 'package:connect/shared/network/local/cache_helper.dart';
import 'package:connect/shared/style/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp();


  await CacheHelper.init();
  String token = await FirebaseMessaging.instance.getToken();
  print('tokeeen $token');

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });

  bool isOnBoardingEnd = CacheHelper.getData(key: 'isOnBoardingEnd');
  uId = CacheHelper.getData(key: 'uId');
  Widget startWidget;
  if(isOnBoardingEnd != null){
    if(uId!=null)
      startWidget = HomeLayout();
      else
    startWidget =LoginScreen();
  }
  else {
    startWidget = OnBoardingScreen();
  }
  runApp(MyApp(startWidget,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget startWidget;

  const MyApp(this.startWidget) ;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SocialCubit()..getUserData()..getPosts(),),
      ],
      child:  MaterialApp(
        title: 'Connect',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}



