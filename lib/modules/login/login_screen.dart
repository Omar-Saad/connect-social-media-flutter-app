import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/home_layout.dart';
import 'package:connect/modules/login/cubit/cubit.dart';
import 'package:connect/modules/register/register_screen.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/network/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit , LoginStates>(
        listener: (context, state) {
          if(state is LoginErrorState){
            showToast(message: state.error, toastState: ToastStates.ERROR);
          }
          else if(state is LoginSuccessState)
            {
              CacheHelper.setData('uId', state.uId).then((value) {
                navigateAndFinish(context, HomeLayout());
              });
            }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return  Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image(image: AssetImage('assets/images/login.png',),
                            width: 220.0,
                            height: 220.0,
                          ),
                        ],
                      ),
                      Text(
                        'LOGIN',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Login to connect with your friends',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultTextFormField(
                        controller: emailController,
                        validator: (String value) {
                          if (value.isEmpty) return 'Email can\'t be empty';
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        prefixIcon: Icons.email_outlined,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultTextFormField(
                        controller: passwordController,
                        validator: (String value) {
                          if (value.isEmpty) return 'Password can\'t be empty';
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        label: 'Password',
                        isPassword: cubit.isPassword,
                        prefixIcon: Icons.lock_open_outlined,
                        suffixIcon: cubit.suffixIcon,
                        onSuffixIconPressed: (){
                          cubit.changePasswordVisibility();
                        },
                        onFieldSubmitted: (value){
                          cubit.userLogin(email: emailController.text, password: passwordController.text);
                        }
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder: (context) =>  defaultButton(
                            text: 'LOGIN',
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                cubit.userLogin(email: emailController.text, password: passwordController.text);
                              }

                            }),
                        fallback:(context) =>  Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account ? '),
                          TextButton(onPressed: () {
                            navigate(context, RegisterScreen());
                          }, child: Text('REGISTER')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}
