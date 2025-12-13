import 'package:flutter/material.dart';
import 'package:flutter_application_mms/appbar/appbars.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = AuthService().firebaseAuth.currentUser?.email ?? 'Unknown User';
    return Scaffold(
      appBar: MyAppBar(title: 'Board'),
      
    );
  }
}