// 필요한 패키지 및 모듈 import
import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_member.dart';

/// UserRole enum에 대한 확장 메서드
/// 드롭다운 메뉴에서 표시할 한글 이름을 반환하는 기능 제공
extension MenuOptionExtension on UserRole {
  /// UserRole enum 값을 한글 표시명으로 변환
  /// - UserRole.user -> '사용자'
  /// - UserRole.admin -> '관리자'
  String get displayName {
    switch (this) {
      case UserRole.user:
        return '사용자';
      case UserRole.admin:
        return '관리자';
    }
  }
}

/// 사용자 추가를 위한 다이얼로그 위젯
/// StatefulWidget을 상속하여 사용자 입력 상태를 관리
class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

/// AddUserDialog의 상태를 관리하는 클래스
/// 사용자 입력값(이름, 이메일, 역할)을 저장하고 관리
class _AddUserDialogState extends State<AddUserDialog> {
  // 이름 입력 필드를 제어하는 컨트롤러
  final TextEditingController _txtNameController = TextEditingController();

  // 이메일 입력 필드를 제어하는 컨트롤러
  final TextEditingController _txtEmailController = TextEditingController();

  // 드롭다운에서 선택된 사용자 역할 (기본값: user)
  UserRole _selectedRole = UserRole.user;

  /// UI를 구성하는 build 메서드
  /// AlertDialog 형태로 사용자 입력 폼을 제공
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 다이얼로그 제목
      title: Text('Member Add'),

      // 스크롤 가능한 콘텐츠 영역
      content: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: ListBody(
          children: [
            // 이름 입력 필드
            // TextInputType.name: 이름 입력에 최적화된 키보드 타입
            TextField(
              controller: _txtNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(height: 15),

            // 이메일 입력 필드
            // TextInputType.emailAddress: 이메일 입력에 최적화된 키보드 타입 (@, . 등 포함)
            TextField(
              controller: _txtEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(height: 15),

            // 사용자 역할 선택 드롭다운 메뉴
            DropdownMenu(
              // 초기 선택값: UserRole.user
              initialSelection: UserRole.user,

              // 드롭다운 메뉴 항목 생성
              // UserRole enum의 모든 값을 DropdownMenuEntry로 변환
              dropdownMenuEntries: UserRole.values
                  .map<DropdownMenuEntry<UserRole>>((UserRole option) {
                    return DropdownMenuEntry<UserRole>(
                      // 실제 선택될 enum 값
                      value: option,
                      // 드롭다운 메뉴와 선택 창에 표시될 한글 텍스트
                      label: option.displayName,
                      // 역할에 따라 다른 아이콘 표시
                      // admin: verified_user 아이콘, user: person 아이콘
                      leadingIcon: option == UserRole.admin
                          ? Icon(Icons.verified_user)
                          : Icon(Icons.person),
                    );
                  })
                  .toList(),

              // 드롭다운에서 항목 선택 시 호출되는 콜백
              onSelected: (value) {
                if (value != null) {
                  // 선택된 역할을 State에 저장하고 UI 업데이트
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
            SizedBox(height: 20),

            // 멤버 추가 버튼
            // 버튼 클릭 시 입력된 정보로 멤버 추가 함수 호출
            ElevatedButton(
              onPressed: () {
                _addMember(
                  context: context,
                  name: _txtNameController.text,
                  email: _txtEmailController.text,
                  role: _selectedRole,
                );
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 새로운 멤버를 Firebase에 추가하는 비동기 함수
///
/// [name] 사용자 이름 (필수)
/// [email] 사용자 이메일 (필수)
/// [role] 사용자 역할 (UserRole enum, 필수)
/// [context] BuildContext (필수, UI 업데이트 및 네비게이션에 사용)
///
/// 반환값: 없음 (void)
///
/// 처리 과정:
/// 1. 이름과 이메일 유효성 검사
/// 2. Firebase에 멤버 추가
/// 3. 결과에 따른 사용자 피드백 제공
/// 4. 성공 시 다이얼로그 자동 닫기
void _addMember({
  required String name,
  required String email,
  required UserRole role,
  required BuildContext context,
}) async {
  // 이름 입력값 유효성 검사
  // 이름이 비어있으면 에러 메시지 표시 후 함수 종료
  if (name.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Name is Empty')));
    return;
  }

  // 이메일 입력값 유효성 검사
  // 이메일이 비어있으면 에러 메시지 표시 후 함수 종료
  if (email.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email is Empty')));
    return;
  }

  // Firebase에 멤버 추가 요청
  // 비동기 작업이므로 await로 결과 대기
  String result = await addMemberToFirebase(
    name: name,
    email: email,
    userRole: role,
  );

  // 비동기 작업 완료 후 위젯이 여전히 마운트되어 있는지 확인
  // 위젯이 dispose된 상태에서 context를 사용하면 오류 발생 가능
  if (!context.mounted) return;

  // Firebase 작업 결과에 따른 사용자 피드백 표시
  // 성공: 'Member added successfully'
  // 실패: 'Failed to add member'
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result == 'success'
            ? 'Member added successfully'
            : 'Failed to add member',
      ),
    ),
  );

  // 멤버 추가가 성공한 경우 다이얼로그 자동 닫기
  // Navigator.pop()을 통해 현재 다이얼로그를 닫고 이전 화면으로 복귀
  if (result == 'success') {
    Navigator.of(context).pop();
  }
}
