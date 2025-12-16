# flutter_application_mms

이 프로젝트는 게시판 기능을 포함한 Flutter 애플리케이션입니다.
사용자는 Firebase 인증을 통해 로그인할 수 있으며, 게시글의 작성, 수정, 삭제와 같은 게시판 관리 기능을 제공합니다.
주요 기능:
- 회원 인증 및 사용자 관리
- 게시글 등록, 수정, 삭제
- 게시글 목록 및 상세 조회

## 프로젝트 구조 트리 및 각 dart 파일 주요 기능

```
lib/
├── main.dart                # 앱 진입점, 라우팅/글로벌 설정
├── models/
│   ├── board.dart           # 게시글(Board) 데이터 모델
│   └── member.dart          # 사용자(Member) 데이터 모델
├── dialog/
│   └── dialogs.dart          # 공통 팝업창 관리 
├── service/
│   ├── validation_service.dart  # 입력값 유효성 검사 함수
│   ├── service_board.dart   # 게시글 CRUD 관련 Firestore 서비스
│   ├── service_member.dart   # 회원 CRUD 관련 Firestore 서비스
│   └── service_auth.dart    # Firebase 인증 및 사용자 관리 서비스
├── views/
│   ├── view_board_list.dart     # 게시글 목록(리스트) 화면
│   ├── view_board_detail.dart   # 게시글 상세 조회 화면
│   ├── view_board_add.dart      # 게시글 등록(작성) 화면
│   ├── view_login.dart      # 로그인/회원가입 화면
│   ├── view_member_add.dart      # 회원 추가 화면
│   ├── view_member_list.dart      # 회원 목록 화면
│   └── view_member_update.dart      # 회원 수정 화면
└── common_widgets/
    ├── appbars.dart     # 공통 AppBar 기능 설정
    └── textformfields.dart      # 공통 TextFormField 기능 설정정
```

### Dart 파일별 주요 기능 요약
- `main.dart`: 앱의 진입점, 전체 전역설정 및 화면 라우팅 관리
- `models/`: 게시글/사용자 등 데이터 구조 모델 정의
- `service/`: Firestore 기반 CRUD, 인증 등 비즈니스 로직 구현
- `views/`: 게시판 UI(리스트/상세/작성/수정 등) 화면 제공
- `widgets/`: 앱 내 재사용 가능한 커스텀 UI 컴포넌트
- `utils/`: 입력 데이터 검증, 상수 등 공통 유틸리티

---

## 프로젝트 주요 기술 및 도입 이유

- **Flutter**: 멀티플랫폼(모바일/web) 대응, 빠른 UI 구성 및 생산성
- **Firebase Auth**: 편리하고 안전한 소셜/이메일 기반 사용자 인증
- **Cloud Firestore**: 실시간 데이터 동기화/저장, 구조적이고 확장성 높은 NoSQL DB
- **intl**: 날짜/시간 포맷 및 다국어 지원

이러한 기술들을 통해 빠른 프로토타입 제작, 안정성, 실시간 데이터 반영, 손쉬운 배포가 가능합니다.

---

## 프로젝트 수행시 습득 가능한 실무 기술

- Flutter 기반 멀티플랫폼 앱 구조 설계 및 폴더링 경험
- Firebase(인증, Firestore 등)와 연동한 실시간 앱 개발 실전 경험
- 게시판 CRUD(등록/수정/삭제/조회) 전반에 걸친 UI와 데이터 로직 설계 및 구현
- 상태관리(State Management) 기초
- 커스텀 위젯/공통 컴포넌트 작성, 폴더/파일 구조화 역량
- 데이터 유효성 검사, 사용자 입력값 처리 등 실무적 개발 습득
- 실시간 동기화되는 리스트/상세 UI 구현

이 프로젝트를 완료하면 Flutter와 Firebase 활용 전반에 걸친 기본적 실력을 갖출 수 있습니다.

구체적인 폴더/파일 구조와 기능은 프로젝트 상황에 따라 확장됩니다.
