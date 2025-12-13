import 'package:flutter/material.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isLoginView)
                TextField(
                  controller: _txtNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              SizedBox(height: 20),
              TextField(
                controller: _txtEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _txtPasswordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                String name = _txtNameController.text;
                String email = _txtEmailController.text;
                String password = _txtPasswordController.text;
                authService.authenticate(isLogin: _isLoginView, email: email, password: password, name: name);
              }, child: Text(_isLoginView ? '로그인 하기' : '회원가입 하기')),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginView = !_isLoginView;
                  });
                },
                child: Text(_isLoginView ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
