import 'package:conditional_builder/conditional_builder.dart';
import 'package:connect/layout/home_layout.dart';
import 'package:connect/modules/register/cubit/cubit.dart';
import 'package:connect/shared/components/components.dart';
import 'package:connect/shared/network/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is RegisterErrorState){
            showToast(message: state.error, toastState: ToastStates.ERROR);
          }
          else if(state is RegisterCreateUserSuccessState){
            CacheHelper.setData('uId', state.uId).then((value) {
              navigateAndFinish(context, HomeLayout());
            });
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                        'REGISTER',
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
                        'Register to connect with your friends',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultTextFormField(
                        controller: nameController,
                        validator: (String value) {
                          if (value.isEmpty) return 'Name can\'t be empty';
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        label: 'Name',
                        prefixIcon: Icons.person,
                      ),
                      SizedBox(
                        height: 16.0,
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
                        }
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultTextFormField(
                        controller: phoneController,
                        validator: (String value) {
                          if (value.isEmpty) return 'Phone can\'t be empty';
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        label: 'Phone',
                        prefixIcon: Icons.phone,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => defaultButton(text: 'REGISTER', onPressed: () {
                          if (formKey.currentState.validate()) {
                            cubit.userRegister(name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text);
                          }
                        }),
                        fallback: (context) => Center(child: CircularProgressIndicator()),
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
