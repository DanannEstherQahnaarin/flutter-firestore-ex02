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
  Future<User?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    UserRole userRole = UserRole.user,
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
          userRole: userRole, // 기본 역할을 'user'로 설정
          timestamp: DateTime.now(), // 회원가입 시점의 타임스탬프
        );

        // Firestore에 회원 정보 저장
        // add() 메서드는 자동으로 문서 ID를 생성합니다.
        await _db.collection(_collection).add(newMember.toFirestore());

        return user;
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

  /// 현재 로그인된 사용자의 회원 정보를 Firestore에서 조회합니다.
  ///
  /// 반환값:
  /// - 성공 시: 로그인된 사용자의 Member 객체
  /// - 실패 시: null (로그인되어 있지 않거나, Firestore에 데이터가 없을 경우)
  ///
  /// 동작 과정:
  /// 1. 현재 로그인된 Firebase Auth의 User 객체를 조회합니다.
  /// 2. 사용자가 없으면(null) 즉시 null을 반환합니다.
  /// 3. Firestore에서 해당 사용자의 uid로 문서를 조회합니다.
  /// 4. 데이터가 존재하면 해당 데이터를 Member 객체로 변환해 반환합니다.
  /// 5. 조회 실패/예외 또는 데이터 미존재 시 null 반환
  Future<Member?> getCurrentMember() async {
    // 현재 로그인 중인 Firebase 사용자 가져오기
    final user = firebaseAuth.currentUser;

    // 만약 로그인된 사용자가 없으면 null 반환
    if (user == null) {
      return null;
    }

    try {
      // Firestore에서 컬렉션(_collection) 내 uid와 일치하는 문서 조회
      final doc = await _db.collection(_collection).doc(user.uid).get();

      // 문서가 존재하며 데이터가 비어있지 않은 경우
      if (doc.exists && doc.data() != null) {
        // 가져온 데이터를 Member 객체로 변환하여 반환
        return Member.fromFirestore(doc.data()!, doc.id);
      }

      // 문서가 없거나 데이터가 없으면 null 반환
      return null;
    } on Exception catch (e) {
      // 예외 발생 시 오류 메시지 출력 후 null 반환
      print('getCurrentMember 예외: $e');
      return null;
    }
  }
}
