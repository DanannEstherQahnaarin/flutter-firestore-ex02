import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_mms/firebase_options.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
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
    final authService = AuthService();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 82, 48, 141))),
      home: StreamBuilder<Member?>(
        stream: AuthService().getMemberStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 이 상태는 Auth 상태를 기다리거나 Firestore 조회를 기다리는 상태입니다.
            return const Center(child: CircularProgressIndicator());
          }

          final Member? userModel = snapshot.data;

          // 1. 로그아웃 상태 또는 Firestore 문서가 없는 경우
          if (userModel == null) {
            // Firestore 문서가 없는 경우(비정상 상태)를 대비해 로그아웃 처리를 한번 더 해줄 수 있습니다.
            // (userModelStream에서 이미 null을 반환했지만, 만약을 위해)
            if (authService.firebaseAuth.currentUser != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                authService.signOut();
              });
            }

            return const UserLogin();
          }

          // 2. 로그인 및 Role 확인 완료 상태

          // 권한에 따라 페이지 분기 (기존 로직 유지)
          if (userModel.userRole == UserRole.admin) {
            return const UserListView();
          } else {
            return const BoardPage();
          }
        },
      ),
    );
  }
}
