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
├── firebase_options.dart    # Firebase 프로젝트 설정 파일
├── models/
│   ├── board.dart           # 게시글(Board) 데이터 모델
│   └── member.dart          # 사용자(Member) 데이터 모델
├── dialog/
│   └── dialogs.dart         # 공통 팝업창 관리 
├── service/
│   ├── service_validation.dart  # 입력값 유효성 검사 함수
│   ├── service_board.dart   # 게시글 CRUD 관련 Firestore 서비스
│   ├── service_member.dart  # 회원 CRUD 관련 Firestore 서비스
│   └── service_auth.dart    # Firebase 인증 및 사용자 관리 서비스
├── views/
│   ├── view_board_list.dart     # 게시글 목록(리스트) 화면
│   ├── view_board_detail.dart   # 게시글 상세 조회 화면
│   ├── view_board_add.dart      # 게시글 등록(작성) 화면
│   ├── view_login.dart          # 로그인/회원가입 화면
│   ├── view_member_add.dart     # 회원 추가 화면
│   ├── view_member_list.dart    # 회원 목록 화면
│   └── view_member_update.dart  # 회원 수정 화면
└── common_widget/
    ├── appbars.dart         # 공통 AppBar 기능 설정
    └── textformfields.dart  # 공통 TextFormField 기능 설정
```

---

## 주요 파일 설명

### Models (`models/`)
- **`member.dart`**: 회원 데이터 모델 정의
  - `UserRole` enum (user, admin) 및 확장 메서드
  - Firestore와의 데이터 변환 (`fromFirestore`, `toFirestore`)
  - 회원 정보 (uid, name, email, userRole, timestamp)

- **`board.dart`**: 게시글 데이터 모델 정의
  - 게시글 정보 (title, content, writerUid, writerNm, readCount, isNotice, timestamp)
  - Firestore와의 데이터 변환 메서드 포함

### Service (`service/`)
- **`service_auth.dart`**: Firebase Authentication 서비스
  - 이메일/비밀번호 회원가입 및 로그인
  - 로그아웃 기능
  - 인증 상태 스트림 관리 (`StreamBuilder` 활용)
  - 회원가입 시 Firestore에 자동 회원 정보 저장

- **`service_member.dart`**: 회원 정보 CRUD 서비스
  - Firestore를 통한 회원 정보 조회, 추가, 수정, 삭제

- **`service_board.dart`**: 게시글 CRUD 서비스
  - Firestore를 통한 게시글 등록, 수정, 삭제, 조회
  - 실시간 데이터 스트림 제공

- **`service_validation.dart`**: 입력값 유효성 검사
  - 이메일, 비밀번호, 필수 입력값 등의 검증 로직

### Views (`views/`)
- **`view_login.dart`**: 로그인/회원가입 화면
- **`view_board_list.dart`**: 게시글 목록 화면 (실시간 업데이트)
- **`view_board_detail.dart`**: 게시글 상세 조회 화면
- **`view_board_add.dart`**: 게시글 등록 화면
- **`view_member_list.dart`**: 회원 목록 화면 (관리자 전용)
- **`view_member_add.dart`**: 회원 추가 화면
- **`view_member_update.dart`**: 회원 정보 수정 화면

### 기타
- **`main.dart`**: 앱 진입점, Firebase 초기화, 인증 상태 기반 라우팅
- **`firebase_options.dart`**: Firebase 프로젝트 플랫폼별 설정 (FlutterFire CLI로 생성)
- **`dialog/dialogs.dart`**: 공통 다이얼로그 및 알림 팝업
- **`common_widget/`**: 재사용 가능한 커스텀 위젯 (AppBar, TextFormField)

---

## 프로젝트 진행하며 습득한 주요 기술

### 1. Firebase 통합
- **Firebase Authentication**: 이메일/비밀번호 기반 인증 구현
- **Cloud Firestore**: NoSQL 데이터베이스를 활용한 실시간 데이터 동기화
- **Firebase 초기화**: 플랫폼별 설정 및 FlutterFire CLI 활용

### 2. Flutter 상태 관리
- **StreamBuilder**: Firebase 스트림을 활용한 실시간 UI 업데이트
- **StatefulWidget**: 동적 상태 관리 (폼 입력, 리스트 등)

### 3. 아키텍처 패턴
- **Service Layer 패턴**: 비즈니스 로직을 서비스 클래스로 분리
- **Model-View 분리**: 데이터 모델과 UI 계층 분리
- **컴포넌트 재사용**: 공통 위젯 및 다이얼로그 모듈화

### 4. 데이터 처리
- **Firestore 변환**: Map ↔ Dart 객체 변환 (`fromFirestore`, `toFirestore`)
- **비동기 프로그래밍**: `async/await`, `Future`, `Stream` 활용
- **에러 처리**: try-catch를 통한 예외 처리 및 사용자 피드백

### 5. UI/UX
- **Material Design**: Flutter Material 위젯 활용
- **Form Validation**: 실시간 입력값 검증
- **Navigation**: 화면 간 이동 및 데이터 전달

### 6. 실무 개발 역량
- **폴더 구조 설계**: 확장 가능한 프로젝트 구조
- **코드 재사용성**: 공통 컴포넌트 및 유틸리티 함수
- **사용자 권한 관리**: Role 기반 접근 제어 (일반 사용자/관리자)

---

## 실행 방법

### 사전 요구사항
- Flutter SDK 3.10.1 이상
- Dart SDK
- Firebase 프로젝트 설정 완료
- 각 플랫폼별 개발 환경 설정 (Android Studio, Xcode 등)

### 설치 및 실행

1. **의존성 패키지 설치**
   ```bash
   flutter pub get
   ```

2. **Firebase 설정 확인**
   - `firebase_options.dart` 파일이 올바르게 생성되어 있는지 확인
   - Firebase Console에서 Authentication과 Firestore가 활성화되어 있는지 확인

3. **앱 실행**
   ```bash
   # Android
   flutter run

   # iOS
   flutter run

   # Web
   flutter run -d chrome

   # Windows
   flutter run -d windows
   ```

4. **빌드**
   ```bash
   # Android APK
   flutter build apk

   # iOS
   flutter build ios

   # Web
   flutter build web
   ```

---

## 사용된 패키지

### 주요 의존성 (dependencies)
- **`flutter`**: Flutter SDK
- **`firebase_core: ^4.2.1`**: Firebase 핵심 기능
- **`cloud_firestore: ^6.1.0`**: Cloud Firestore 데이터베이스
- **`firebase_auth: ^6.1.2`**: Firebase Authentication (이메일/비밀번호 인증)
- **`intl: ^0.20.2`**: 국제화 및 날짜/시간 포맷팅
- **`cupertino_icons: ^1.0.8`**: iOS 스타일 아이콘

### 개발 의존성 (dev_dependencies)
- **`flutter_test`**: Flutter 테스트 프레임워크
- **`flutter_lints: ^6.0.0`**: Flutter 코드 린팅 규칙

---

## 개발 환경

- **언어**: Dart 3.10.1
- **프레임워크**: Flutter
- **백엔드**: Firebase (Authentication, Cloud Firestore)
- **개발 도구**: 
  - Flutter SDK
  - Firebase Console
  - FlutterFire CLI (Firebase 설정용)
- **지원 플랫폼**: Android, iOS, Web, Windows, macOS

---

## 주요 구현 포인트

### 1. 인증 상태 기반 라우팅
```dart
// main.dart에서 StreamBuilder를 활용한 실시간 인증 상태 감지
StreamBuilder<Member?>(
  stream: AuthService().getMemberStream,
  builder: (context, snapshot) {
    // 로그인 상태에 따라 화면 자동 전환
    // 관리자는 회원 목록, 일반 사용자는 게시판으로 이동
  }
)
```

### 2. 실시간 데이터 동기화
- Firestore의 `Stream`을 활용하여 데이터 변경 시 UI 자동 업데이트
- 게시글 목록, 회원 목록 등이 실시간으로 반영됨

### 3. Role 기반 접근 제어
- `UserRole` enum을 통한 사용자 권한 관리
- 관리자만 회원 관리 화면 접근 가능
- 일반 사용자는 게시판 기능만 사용

### 4. Firestore 데이터 모델 변환
- `fromFirestore`: Firestore 문서를 Dart 객체로 변환
- `toFirestore`: Dart 객체를 Firestore 문서로 변환
- 타임스탬프, enum 등 복잡한 데이터 타입 처리

### 5. 입력값 유효성 검사
- 이메일 형식 검증
- 비밀번호 길이 및 복잡도 검증
- 필수 입력값 검증
- 실시간 피드백 제공

### 6. 에러 처리 및 사용자 피드백
- try-catch를 통한 예외 처리
- 사용자 친화적인 에러 메시지 표시
- 다이얼로그를 통한 알림 및 확인

### 7. 코드 재사용성
- 공통 AppBar 위젯 (`common_widget/appbars.dart`)
- 공통 TextFormField 위젯 (`common_widget/textformfields.dart`)
- 공통 다이얼로그 (`dialog/dialogs.dart`)

---

## 추가

### 향후 개선 사항
- 게시글 검색 기능
- 게시글 페이징 처리
- 이미지 업로드 기능 (Firebase Storage 활용)
- 댓글 기능
- 좋아요/북마크 기능
- 알림 기능 (Firebase Cloud Messaging)

### 참고 자료
- [Flutter 공식 문서](https://flutter.dev/docs)
- [Firebase Flutter 문서](https://firebase.flutter.dev/)
- [Cloud Firestore 문서](https://firebase.google.com/docs/firestore)

---

