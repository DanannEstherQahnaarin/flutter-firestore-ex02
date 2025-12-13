import 'package:flutter/material.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
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
                  TextFormField(
                    controller: _txtNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름을 입력하여 주십시오.';
                      }

                      return null;
                    },
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _txtEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력하여 주십시오.';
                    } else {
                      final emailRegExp = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      );

                      if (!emailRegExp.hasMatch(value)) {
                        return '유효하지 않은 이메일 형식입니다.';
                      }

                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _txtPasswordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '패스워드를 입력하여 주십시오.';
                    }

                    if (!_isLoginView && value.length < 6) {
                      return '패스워드를 6자 이상 입력하여 주십시오.';
                    }

                    return null;
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
                        authService
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
                        authService
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
