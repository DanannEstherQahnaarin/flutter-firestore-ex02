import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mms/firebase_options.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
import 'package:flutter_application_mms/views/view_board_add.dart';
import 'package:flutter_application_mms/views/view_board_list.dart';
import 'package:flutter_application_mms/views/view_login.dart';
import 'package:flutter_application_mms/views/view_member_list.dart';

void main() async {
  // Flutter 엔진과 위젯 바인딩이 초기화될 때까지 기다립니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 82, 48, 141))),
      home: StreamBuilder<User?>(
        stream: AuthService().member,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return UserLogin();
          }

          return FutureBuilder(
            future: AuthService().getCurrentMember(),
            builder: (context, userSnapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final member = userSnapshot.data;

              if (member == null) {
                AuthService().signOut();
                return UserLogin();
              }

              if (member.userRole == UserRole.admin) {
                return UserListView();
              } else {
                return BoardPage();
              }
            },
          );
        },
      ),
    );
  }
}
