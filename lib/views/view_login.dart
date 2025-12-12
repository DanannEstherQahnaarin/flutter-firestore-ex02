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
      appBar: AppBar(title: Text(_isLoginView ? '로그인':'회원가입'),),
      body: Center(
        child: SingleChildScrollView(
          
        ),
      ),
    );
  }
}
