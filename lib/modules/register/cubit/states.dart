abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates{}

class RegisterChangePasswordVisibilityState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates{}
class RegisterErrorState extends RegisterStates{
  final String error;

  RegisterErrorState(this.error);
}


class RegisterCreateUserSuccessState extends RegisterStates{
  final String uId;

  RegisterCreateUserSuccessState(this.uId);
}
class RegisterCreateUserErrorState extends RegisterStates{
  final String error;

  RegisterCreateUserErrorState(this.error);
}