// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:task_manager/constants/supabase_constants.dart';
// import 'package:task_manager/core/injection/injection.dart';
// import 'package:task_manager/repositories/auth_repository.dart';
// import 'package:task_manager/pages/login_page/login_state.dart';
//
// @injectable
// class RegisterCubit extends Cubit<LoginState> {
//   late AuthRepository _authRepository;
//
//   RegisterCubit() : super(LoginState()) {
//     _authRepository = getIt<AuthRepository>();
//   }
//
//   void signIn(BuildContext context) async {
//     FocusScope.of(context).unfocus();
//     setLoading(true);
//
//     final response = await _authRepository.signIn(
//         state.emailController.text, state.passwordController.text);
//
//     // response.either(
//     //   (error) => {context.showErrorSnackBar(message: error)},
//     //   (success) => {
//     //     if (success)
//     //       Navigator.pushNamedAndRemoveUntil(context, '/today', (route) => false)
//     //   },
//     // );
//     if (response.isLeft) {
//       context.showErrorSnackBar(message: response.left);
//     } else if (response.isRight) {
//       Navigator.pushNamedAndRemoveUntil(context, '/today', (route) => false);
//     }
//
//     Future.delayed(Duration(seconds: 1), () => setLoading(false));
//     // setLoading(false);
//   }
//
//   void googleSignIn(BuildContext context) async {
//     FocusScope.of(context).unfocus();
//     setLoading(true);
//
//     context.showSnackBar(message: 'Redirecting to the Google page');
//     await _authRepository.signInWithGoogle();
//
//     setLoading(false);
//   }
//
//   setLoading(bool loading) {
//     state.loading = loading;
//     emit(state);
//   }
// }
