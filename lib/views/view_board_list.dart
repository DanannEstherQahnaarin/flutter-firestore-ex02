import 'package:flutter/material.dart';
import 'package:flutter_application_mms/common_widget/appbars.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
import 'package:flutter_application_mms/views/view_board_add.dart';
import 'package:intl/intl.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = AuthService().firebaseAuth.currentUser?.email ?? 'Unknown User';
    return Scaffold(
      appBar: MyAppBar(title: 'Board'),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream: AuthService().getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final boards = snapshot.data;

                if (boards == null || boards.isEmpty) {
                  return const Center(child: Text('등록된 글이 없습니다.'));
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final post = boards[index];
                    // 날짜 포맷을 위해 intl 패키지 사용
                    final formattedDate = DateFormat('yy/MM/dd HH:mm').format(post.timestamp);

                    return ListTile(
                      title: Text(
                        post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            '작성자: ${post.writerNm} | 시간: $formattedDate',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () {
                        // TODO: 10단계에서 게시글 상세/수정 페이지로 이동 로직 구현
                        print('게시글 선택 ID: ${post.id}');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBordPage()),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
