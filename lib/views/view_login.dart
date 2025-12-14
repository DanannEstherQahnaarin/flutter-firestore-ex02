import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/textformfields.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
import 'package:flutter_application_mms/service/service_validation.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _txtNameController = TextEditingController();
  final TextEditingController _txtEmailController = TextEditingController();
  final TextEditingController _txtPasswordController = TextEditingController();
  bool _isLoginView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLoginView ? '로그인' : '회원가입')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isLoginView)
                  CustomInputFormField(
                    controller: _txtNameController,
                    labelText: 'Name',
                    validator: (value) {
                      return ValidationService.validateRequired(
                        value: value ?? '',
                        fieldName: '사용자 이름',
                      );
                    },
                  ),
                SizedBox(height: 20),
                CustomInputFormField(
                  controller: _txtEmailController,
                  labelText: 'Email',
                  validator: (value) {
                    return ValidationService.validateEmail(value: value ?? '');
                  },
                ),
                SizedBox(height: 20),
                CustomInputFormField(
                  controller: _txtPasswordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: (value) {
                    return ValidationService.validatePassword(
                      value: value ?? '',
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String name = _txtNameController.text;
                      String email = _txtEmailController.text;
                      String password = _txtPasswordController.text;

                      if (_isLoginView) {
                        _authService
                            .signInWithEmail(email: email, password: password)
                            .then((result) {
                              if (result == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('로그인에 실패하였습니다.'),
                                  ),
                                );
                              }
                            });
                        return;
                      }

                      if (!_isLoginView) {
                        _authService
                            .signUpWithEmail(
                              name: name,
                              email: email,
                              password: password,
                            )
                            .then((result) {
                              if (result == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('회원가입에 실패하였습니다.'),
                                  ),
                                );
                              }
                            });
                        return;
                      }
                    }
                  },
                  child: Text(_isLoginView ? '로그인 하기' : '회원가입 하기'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginView = !_isLoginView;
                    });
                  },
                  child: Text(
                    _isLoginView ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인',
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
