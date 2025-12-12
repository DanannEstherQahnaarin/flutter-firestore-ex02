import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_mms/models/member.dart';

/// Firebase Authentication을 관리하는 서비스 클래스
///
/// 이 클래스는 사용자 인증 관련 기능을 제공합니다:
/// - 이메일/비밀번호로 회원가입
/// - 이메일/비밀번호로 로그인
/// - 로그아웃
/// - 인증 상태 변경 스트림
///
/// 회원가입 시 Firestore에 회원 정보를 자동으로 저장합니다.
class AuthService {
  /// Firebase Authentication 인스턴스
  /// 인증 관련 작업(회원가입, 로그인, 로그아웃)에 사용됩니다.
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Firestore 데이터베이스 인스턴스
  /// 회원 정보를 저장하고 조회하는 데 사용됩니다.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Firestore 컬렉션 이름
  /// 회원 정보가 저장되는 컬렉션의 이름입니다.
  final String _collection = 'mms';

  /// 현재 인증 상태를 실시간으로 관찰할 수 있는 스트림
  ///
  /// 사용자가 로그인하면 User 객체를, 로그아웃하면 null을 방출합니다.
  Stream<User?> get member => firebaseAuth.authStateChanges();

  /// 이메일과 비밀번호로 새 사용자를 등록합니다.
  ///
  /// 이 메서드는 다음 작업을 수행합니다:
  /// 1. Firebase Authentication에 새 사용자 계정 생성
  /// 2. 생성된 사용자의 UID를 사용하여 Firestore에 회원 정보 저장
  ///
  /// [name] 회원의 이름 (필수)
  /// [email] 회원가입에 사용할 이메일 주소 (필수)
  /// [password] 회원가입에 사용할 비밀번호 (필수, 최소 6자 이상)
  ///
  /// 반환값:
  /// - 성공 시: 생성된 Member 객체
  /// - 실패 시: null (FirebaseAuthException 발생)
  ///
  /// 예외:
  /// - `FirebaseAuthException`: 이메일 형식 오류, 비밀번호 너무 짧음,
  ///   이미 존재하는 이메일 등 인증 관련 오류 발생 시
  Future<Member?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authentication에 새 사용자 계정 생성
      // 이메일과 비밀번호를 사용하여 인증 정보를 생성합니다.
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 생성된 사용자 정보 가져오기
      // result.user는 새로 생성된 사용자 객체를 포함합니다.
      User? user = result.user;

      // 사용자가 성공적으로 생성되었는지 확인
      if (user != null) {
        // Firestore에 저장할 Member 객체 생성
        // Firebase Auth의 UID를 사용하여 Member를 생성합니다.
        final newMember = Member(
          uid: user.uid, // Firebase Auth에서 생성된 고유 사용자 ID
          name: name, // 사용자가 입력한 이름
          email: email, // 사용자가 입력한 이메일
          userRole: UserRole.user, // 기본 역할을 'user'로 설정
          timestamp: DateTime.now(), // 회원가입 시점의 타임스탬프
        );

        // Firestore에 회원 정보 저장
        // add() 메서드는 자동으로 문서 ID를 생성합니다.
        await _db.collection(_collection).add(newMember.toFirestore());

        // 생성된 Member 객체 반환
        return newMember;
      }

      // 사용자 생성 실패 시 null 반환
      return null;
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 관련 오류 처리
      // 예: 이메일 형식 오류, 약한 비밀번호, 이미 존재하는 이메일 등
      print(e.message);
      // TODO: 적절한 오류 처리를 위해 null 반환 또는 예외 재발생 고려
      return null;
    }
  }

  /// 이메일과 비밀번호로 기존 사용자를 로그인시킵니다.
  ///
  /// [email] 로그인에 사용할 이메일 주소 (필수)
  /// [password] 로그인에 사용할 비밀번호 (필수)
  ///
  /// 반환값:
  /// - 성공 시: 로그인된 User 객체
  /// - 실패 시: null (예외 발생 시)
  ///
  /// 예외:
  /// - 잘못된 이메일/비밀번호, 사용자 계정이 비활성화됨 등의 오류 발생 가능
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authentication을 사용하여 로그인 시도
      // 제공된 이메일과 비밀번호로 사용자 인증을 수행합니다.
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공 시 User 객체 반환
      return result.user;
    } catch (e) {
      // 모든 예외를 잡아서 처리
      // 로그인 실패 시 null을 반환합니다.
      // TODO: 오류 유형에 따른 적절한 오류 메시지 반환 고려
      return null;
    }
  }

  // 현재 로그인된 사용자를 로그아웃시킵니다.
  // 로그아웃 후 authStateChanges() 스트림은 null을 방출합니다.
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// 로그인 또는 회원가입을 수행하는 통합 인증 메서드
  ///
  /// [isLogin]의 값에 따라 로그인 또는 회원가입을 자동으로 선택합니다.
  /// 하나의 메서드로 두 가지 인증 작업을 처리할 수 있어 UI 코드를 단순화할 수 있습니다.
  ///
  /// **로그인 모드** (isLogin = true):
  /// - [email]과 [password]만 사용하여 기존 사용자 로그인
  /// - [name] 파라미터는 무시됨
  /// - signInWithEmail() 메서드를 내부적으로 호출
  /// - 반환값: null (로그인은 User 객체 반환, Member는 반환하지 않음)
  ///
  /// **회원가입 모드** (isLogin = false):
  /// - [email], [password], [name]을 사용하여 새 사용자 등록
  /// - [name]이 null이거나 비어있으면 ArgumentError 발생
  /// - signUpWithEmail() 메서드를 내부적으로 호출
  /// - 반환값: 생성된 Member 객체 (성공 시) 또는 null (실패 시)
  ///
  /// [isLogin] 로그인 모드인지 여부 (true: 로그인, false: 회원가입)
  /// [email] 사용자 이메일 주소 (필수, 로그인/회원가입 공통)
  /// [password] 사용자 비밀번호 (필수, 로그인/회원가입 공통)
  /// [name] 사용자 이름 (회원가입 시에만 필수, 로그인 시에는 무시됨)
  ///
  /// 반환값:
  /// - 로그인 모드: null (로그인은 User 객체 반환, Member는 반환하지 않음)
  /// - 회원가입 모드: 생성된 Member 객체 (성공 시) 또는 null (실패 시)
  Future<Member?> authenticate({
    required bool isLogin,
    required String email,
    required String password,
    String? name,
  }) async {
    // 로그인 모드 처리
    // isLogin이 true이면 기존 사용자 로그인을 수행합니다.
    if (isLogin) {
      // 로그인 수행
      // signInWithEmail은 User 객체를 반환하지만,
      // 이 메서드는 Member 객체를 반환하므로 null을 반환합니다.
      // 실제 User 객체는 member 스트림을 통해 확인 가능합니다.
      await signInWithEmail(email: email, password: password);
      // 로그인 성공 여부와 관계없이 null 반환
      // (로그인은 User 반환, Member는 반환하지 않음)
      return null;
    }

    // 회원가입 모드 처리
    // isLogin이 false이면 새 사용자 회원가입을 수행합니다.
    // name이 null이거나 비어있으면 명시적으로 예외 발생
    if (name == null || name.trim().isEmpty) {
      throw ArgumentError('회원가입 모드에서는 name이 필수이며 비어있을 수 없습니다.', 'name');
    }

    // 회원가입 수행 및 결과 반환
    // signUpWithEmail은 Member 객체를 반환합니다.
    // 성공 시 Member 객체, 실패 시 null을 반환합니다.
    final member = await signUpWithEmail(
      name: name,
      email: email,
      password: password,
    );
    return member;
  }
}
