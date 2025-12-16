# flutter_application_mms

이 프로젝트는 게시판 기능을 포함한 Flutter 애플리케이션입니다.
사용자는 Firebase 인증을 통해 로그인할 수 있으며, 게시글의 작성, 수정, 삭제와 같은 게시판 관리 기능을 제공합니다.
주요 기능:
- 회원 인증 및 사용자 관리
- 게시글 등록, 수정, 삭제
- 게시글 목록 및 상세 조회

## 프로젝트 구조 및 각 dart별 기능 정의

- **lib/main.dart**  
  앱의 진입점, 라우팅 및 앱 전체 설정 관리

- **lib/views/**  
  주요 화면(UI) 구성 파일 위치
  - `view_board_list.dart` : 게시판 목록 화면
  - `view_board_detail.dart` : 게시글 상세 조회 화면
  - `view_board_add.dart` : 게시글 작성 화면
  - `view_board_edit.dart` : 게시글 수정 화면

- **lib/service/**  
  비즈니스 로직 및 Firestore, 인증 등 서비스 코드 위치
  - `service_board.dart` : 게시판(글 등록/수정/삭제/조회) 관련 서비스 함수
  - `service_auth.dart` : Firebase 인증 및 사용자 관리 로직

- **lib/models/**  
  데이터 모델 정의
  - `board.dart` : 게시글(Board) 데이터 모델 정의
  - `member.dart` : 사용자(Member) 데이터 모델 정의

- **lib/widgets/**  
  공통 위젯 및 커스텀 UI 컴포넌트 위치
  - `custom_input_form_field.dart` : 재사용 입력 폼 필드 위젯 등

- **lib/utils/**  
  공통 유틸리티, 검증 함수 등
  - `validation_service.dart` : 입력값 유효성 검사 함수
  - `constants.dart` : 상수 정의

구체적인 폴더/파일 구조와 기능은 프로젝트 상황에 따라 확장됩니다.

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
