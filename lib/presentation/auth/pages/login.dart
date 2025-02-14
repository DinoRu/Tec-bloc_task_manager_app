import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/data/auth/models/user_login_req.dart';
import 'package:tec_bloc/domain/auth/usecases/login.dart';
import 'package:tec_bloc/service_locator.dart';

import '../../tasks/home/pages/home.dart';
import '../widgets/my_textformfield.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;


  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
        _errorMsg = null;
      });
      final loginUseCase = sl<LoginUseCase>();
      final result = await loginUseCase(
        params: UserLoginReq(
          username: usernameController.text, 
          password: passwordController.text
        )
      );
      result.fold(
        (failure) {
          debugPrint(failure.toString());
          setState(() {
            isLoading = false;
            _errorMsg = failure.toString();
          });
        }, 
        (token) {
          setState(() {
            isLoading = false;
            AppNavigator.pushReplacement(context, const Home());
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppText.title,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextFormField(
                    controller: usernameController,
                    hintText: "Имя пользователь",
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Пожалуйста, заполните это поле";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextFormField(
                    controller: passwordController,
                    hintText: "Пароль",
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Пожалуйста, заполните это поле';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(iconPassword),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          if (obscurePassword) {
                            iconPassword = CupertinoIcons.eye_fill;
                          } else {
                            iconPassword = CupertinoIcons.eye_slash_fill;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          )
                        : const Text(
                            'Вход',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
