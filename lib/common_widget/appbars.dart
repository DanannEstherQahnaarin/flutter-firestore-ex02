import 'package:flutter/material.dart';
import 'package:flutter_application_mms/dialog/dialogs.dart';
import 'package:flutter_application_mms/service/service_auth.dart';

/// 커스텀 AppBar 위젯
///
/// 이 위젯은 앱 상단바 역할을 하며,
/// - 화면 제목 [title]을 표시
/// - 오른쪽에 로그인한 사용자 이름, 이메일을 보여주고
/// - 로그아웃 버튼(아이콘)을 제공함
///
/// PreferredSizeWidget을 구현하여 AppBar로 사용 가능
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 화면 제목 텍스트
  final String title;

  /// 인증 서비스 인스턴스 (사용자 정보 조회 등에 활용)
  final AuthService authService = AuthService();

  /// 생성자. 필수로 제목을 지정.
  MyAppBar({super.key, required this.title});

  /// AppBar를 빌드하는 메서드
  ///
  /// - AppBar 위젯에 타이틀, 사용자 정보, 로그아웃 버튼 렌더링
  /// - 사용자 정보는 Firebase에서 비동기로 가져오기 위해 FutureBuilder 사용
  @override
  Widget build(BuildContext context) {
    final currentUserEmail = AuthService().firebaseAuth.currentUser?.email ?? '';
    final currentUserName = AuthService().firebaseAuth.currentUser?.displayName ?? '';
    return AppBar(
      // AppBar의 중앙 타이틀
      title: Text(title),
      // AppBar의 우측 action 영역 (사용자 정보, 로그아웃 버튼)
      actions: [
        Text(currentUserName),
        Text(currentUserEmail),
        // 로그아웃 버튼 (오른쪽 아이콘)
        IconButton(
          onPressed: () {
            // 로그아웃 다이얼로그 호출 (dialog/dialogs.dart)
            showSignoutDialog(context: context);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  /// AppBar 크기 지정 (필수: PreferredSizeWidget 구현을 위함)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
