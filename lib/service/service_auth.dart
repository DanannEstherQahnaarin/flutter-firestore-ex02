import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_mms/models/board.dart';
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
  final String _memberCollection = 'member_collection';

  final String _boardCollection = 'board_collection';

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
      final UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 생성된 사용자 정보 가져오기
      // result.user는 새로 생성된 사용자 객체를 포함합니다.
      final User? user = result.user;

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
        await _db.collection(_memberCollection).doc(user.uid).set(newMember.toFirestore());

        return user;
      }

      // 사용자 생성 실패 시 null 반환
      return null;
    } on FirebaseAuthException catch (e) {
      // Firebase 인증 관련 오류 처리
      // 예: 이메일 형식 오류, 약한 비밀번호, 이미 존재하는 이메일 등
      debugPrint(e.message);
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
  Future<User?> signInWithEmail({required String email, required String password}) async {
    try {
      // Firebase Authentication을 사용하여 로그인 시도
      // 제공된 이메일과 비밀번호로 사용자 인증을 수행합니다.
      final UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공 시 User 객체 반환
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // 현재 로그인된 사용자를 로그아웃시킵니다.
  // 로그아웃 후 authStateChanges() 스트림은 null을 방출합니다.
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// 주어진 Firebase User의 UID로 Firestore에서 Member 모델을 조회하여 반환합니다.
  ///
  /// 상세 기능:
  /// - 해당 사용자의 UID로 members 컬렉션에서 도큐먼트를 조회합니다.
  /// - 도큐먼트가 존재하고 데이터가 있을 경우 Member 모델로 변환하여 반환합니다.
  /// - 도큐먼트가 없거나 예외가 발생하면 null을 반환합니다.
  ///
  /// [user] Firebae 인증 User 객체(필수)
  /// 반환: 존재하는 경우 Member, 없거나 오류시 null
  Future<Member?> getUserModelByUid(User user) async {
    try {
      final doc = await _db.collection(_memberCollection).doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        return Member.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      debugPrint('사용자 모델 로딩 오류: $e');
      return null;
    }
  }

  /// 현재 인증 상태에 따라 사용자 Member 스트림을 제공합니다.
  ///
  /// 상세 기능:
  /// - 인증 상태(authStateChanges)가 변경될 때마다, User가 없으면(null) 즉시 null을 반환합니다.
  /// - User가 있다면 getUserModelByUid처럼 해당 UID의 members 문서를 조회, 존재 시 Member로 반환합니다.
  /// - 오류나 도큐먼트 없음 등 모든 실패 케이스에서 null 반환.
  ///
  /// 사용 예: 로그인, 로그아웃, 가입 등 인증 상태에 따른 자동 Member 정보 스트리밍 처리에 사용.
  Stream<Member?> get getMemberStream =>
      firebaseAuth.authStateChanges().asyncMap((user) async {
        // 1. 로그아웃 상태: user가 null이면 즉시 null 반환 (UserModel 없음)
        if (user == null) {
          return null;
        }

        // 2. 로그인 상태: Firestore에서 해당 UID의 UserModel을 조회
        //    (userModelByUid 함수를 재활용하거나 인라인으로 구현)
        try {
          final doc = await _db.collection(_memberCollection).doc(user.uid).get();

          if (doc.exists && doc.data() != null) {
            // UserModel 객체를 반환
            return Member.fromFirestore(doc.data()!, doc.id);
          }
          // 문서가 존재하지 않는 경우 (비정상 상태)
          return null;
        } catch (e) {
          debugPrint('userModelStream 오류: $e');
          return null;
        }
      });

  /// 게시글(Board) 목록을 스트림으로 실시간 제공
  ///
  /// 상세 기능:
  /// - boards 컬렉션의 모든 게시글을 timestamp 기준으로 내림차순 정렬하여 스트림으로 반환합니다.
  /// - Firestore의 실시간 snapshots()를 사용하여 변화가 있을 때마다 List<Board> 갱신.
  /// - 각 도큐먼트는 Board.fromFirestore를 이용해 변환함.
  ///
  /// 사용 예: 게시판 목록 화면 등에 실시간 반영 가능
  Stream<List<Board>> getPostsStream() => _db
      .collection(_boardCollection)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Board.fromFirestore(doc.data(), doc.id)).toList(),
      );

  /// 새 게시글(Board) 데이터를 Firestore에 추가
  ///
  /// 상세 기능:
  /// - boards 컬렉션에 Board 객체의 데이터를 추가합니다.
  /// - 실패 시 예외를 캡처하여 debugPrint로 출력합니다(에러 처리는 별도로 필요할 수 있음).
  Future<void> addBoard(Board board) async {
    try {
      await _db.collection(_boardCollection).add(board.toFirestore());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  /// 기존 게시글(Board)을 Firestore에서 수정
  ///
  /// 상세 기능:
  /// - board.id가 없으면 즉시 예외를 throw하여 중단합니다.
  /// - 주어진 board.id로 해당 게시글 도큐먼트를 찾아, 데이터를 update합니다.
  /// - 실패 시 에러 내용을 debugPrint로 출력합니다.
  Future<void> updateBoard(Board board) async {
    if (board.id == null) {
      throw Exception('아이디가 없습니다.');
    }

    try {
      await _db.collection(_boardCollection).doc(board.id).update(board.toFirestore());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  /// 기존 게시글(Board)을 Firestore에서 삭제
  ///
  /// 상세 기능:
  /// - board.id가 없으면 즉시 예외를 throw하여 중단합니다.
  /// - 주어진 board.id로 해당 게시글 도큐먼트를 찾아, 삭제합니다.
  /// - 실패 시 에러 내용을 debugPrint로 출력합니다.
  Future<void> deleteBoard(Board board) async {
    if (board.id == null) {
      throw Exception('아이디가 없습니다.');
    }

    try {
      await _db.collection(_boardCollection).doc(board.id).delete();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
