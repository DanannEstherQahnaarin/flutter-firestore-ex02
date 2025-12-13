import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_mms/models/member.dart';

/// Firebase Firestore 데이터베이스 인스턴스
/// 애플리케이션 전체에서 공유되는 단일 인스턴스
final FirebaseFirestore _db = FirebaseFirestore.instance;

/// Firestore 컬렉션 이름
/// 멤버 데이터를 저장하는 컬렉션의 이름 ('mms')
final String _collection = 'mms';

/// 작업 결과를 나타내는 enum
/// - success: 작업 성공
/// - fail: 작업 실패
enum Answer { success, fail }

/// Firestore에서 멤버 목록을 실시간으로 가져오는 Stream 함수
///
/// 반환값: Stream<List<Member>>
/// - 실시간으로 업데이트되는 멤버 목록 스트림
/// - 데이터베이스 변경 시 자동으로 새로운 데이터를 emit
///
/// 처리 과정:
/// 1. 'mms' 컬렉션에서 데이터 조회
/// 2. 'timestamp' 필드를 기준으로 정렬 (오름차순)
/// 3. 실시간 스냅샷 스트림 생성
/// 4. 각 문서를 Member 객체로 변환하여 리스트로 반환
///
/// 사용 예시:
/// StreamBuilder<List<Member>>(
///   stream: getMemberStream(),
///   builder: (context, snapshot) { ... }
/// )
Stream<List<Member>> getMemberStream() {
  return _db
      // 'mms' 컬렉션 참조
      .collection(_collection)
      // timestamp 필드를 기준으로 정렬 (오름차순)
      .orderBy('timestamp')
      // 실시간 스냅샷 스트림 생성 (데이터 변경 시 자동 업데이트)
      .snapshots()
      // 스냅샷을 Member 객체 리스트로 변환
      .map(
        (snapshot) => snapshot.docs
            // 각 문서를 Member 객체로 변환
            // doc.data(): 문서의 데이터 (Map<String, dynamic>)
            // doc.id: 문서의 고유 ID
            .map((doc) => Member.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
}

/// 새로운 멤버를 Firestore에 추가하는 비동기 함수
///
/// 매개변수:
/// - [name] 사용자 이름 (필수)
/// - [email] 사용자 이메일 (필수)
/// - [userRole] 사용자 역할 (UserRole enum, 필수)
///
/// 반환값: Future<String>
/// - 'success': 멤버 추가 성공
/// - 'fail': 멤버 추가 실패
///
/// 처리 과정:
/// 1. 전달받은 정보로 Member 객체 생성 (현재 시간을 timestamp로 설정)
/// 2. Member 객체를 Firestore 문서 형식(Map)으로 변환
/// 3. 'mms' 컬렉션에 새 문서 추가
/// 4. 성공/실패 결과를 문자열로 반환
///
/// 예외 처리:
/// - try-catch로 감싸서 오류 발생 시 'fail' 반환
Future<String> addMemberToFirebase({
  required String name,
  required String uid,
  required String email,
  required UserRole userRole,
}) async {
  // 전달받은 정보로 Member 객체 생성
  // timestamp는 현재 시간으로 자동 설정
  final addMember = Member(
    name: name,
    uid:uid,
    email: email,
    userRole: userRole,
    timestamp: DateTime.now(),
  );

  try {
    // 'mms' 컬렉션에 새 문서 추가
    // toFirestore(): Member 객체를 Firestore 문서 형식(Map)으로 변환
    await _db.collection(_collection).add(addMember.toFirestore());

    // 성공 시 'success' 문자열 반환
    return Answer.success.name;
  } catch (e) {
    // 오류 발생 시 'fail' 문자열 반환
    // e: 발생한 예외 객체 (로깅 등에 사용 가능)
    return Answer.fail.name;
  }
}

/// 기존 멤버 정보를 Firestore에서 업데이트하는 비동기 함수
///
/// 매개변수:
/// - [member] 업데이트할 Member 객체 (필수, id 필드가 반드시 있어야 함)
///
/// 반환값: Future<String>
/// - 'success': 멤버 업데이트 성공
/// - 'fail': 멤버 업데이트 실패
///
/// 처리 과정:
/// 1. member.id를 사용하여 특정 문서 참조
/// 2. Member 객체를 Firestore 문서 형식(Map)으로 변환
/// 3. 해당 문서의 데이터 업데이트
/// 4. 성공/실패 결과를 문자열로 반환
///
/// 주의사항:
/// - member.id가 null이면 오류 발생
/// - 존재하지 않는 문서 ID로 업데이트 시도 시 오류 발생
///
/// 예외 처리:
/// - try-catch로 감싸서 오류 발생 시 'fail' 반환
Future<String> updateMemberToFirebase({required Member member}) async {
  try {
    // 'mms' 컬렉션에서 member.id에 해당하는 문서를 찾아 업데이트
    // doc(member.id): 특정 문서 ID로 문서 참조
    // update(): 문서의 필드들을 업데이트 (기존 필드는 유지, 지정한 필드만 변경)
    await _db
        .collection(_collection)
        .doc(member.id)
        .update(member.toFirestore());

    // 성공 시 'success' 문자열 반환
    return Answer.success.name;
  } catch (e) {
    // 오류 발생 시 'fail' 문자열 반환
    // e: 발생한 예외 객체 (로깅 등에 사용 가능)
    return Answer.fail.name;
  }
}

/// Firestore에서 멤버를 삭제하는 비동기 함수
///
/// 매개변수:
/// - [member] 삭제할 Member 객체 (필수, id 필드가 반드시 있어야 함)
///
/// 반환값: Future<String>
/// - 'success': 멤버 삭제 성공
/// - 'fail': 멤버 삭제 실패
///
/// 처리 과정:
/// 1. member.id를 사용하여 특정 문서 참조
/// 2. 해당 문서를 Firestore에서 삭제
/// 3. 성공/실패 결과를 문자열로 반환
///
/// 주의사항:
/// - member.id가 null이면 오류 발생
/// - 존재하지 않는 문서 ID로 삭제 시도 시 오류 발생
/// - 삭제된 데이터는 복구할 수 없음
///
/// 예외 처리:
/// - try-catch로 감싸서 오류 발생 시 'fail' 반환
Future<String> deleteMemberToFirebase({required Member member}) async {
  try {
    // 'mms' 컬렉션에서 member.id에 해당하는 문서를 찾아 삭제
    // doc(member.id): 특정 문서 ID로 문서 참조
    // delete(): 해당 문서를 완전히 삭제
    await _db.collection(_collection).doc(member.id).delete();

    // 성공 시 'success' 문자열 반환
    return Answer.success.name;
  } catch (e) {
    // 오류 발생 시 'fail' 문자열 반환
    // e: 발생한 예외 객체 (로깅 등에 사용 가능)
    return Answer.fail.name;
  }
}
