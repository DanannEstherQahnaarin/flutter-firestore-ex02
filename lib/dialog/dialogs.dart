import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/board.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/service/service_auth.dart';
import 'package:flutter_application_mms/service/service_board.dart';
import 'package:flutter_application_mms/service/service_member.dart';
import 'package:flutter_application_mms/views/view_member_add.dart';
import 'package:flutter_application_mms/views/view_member_update.dart';

Future<void> showAddUserDialog({required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => const AddUserDialog(),
  );
}

Future<void> showUpdateUserDialog({
  required Member member,
  required BuildContext context,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => UpdateUserDialog(updateMember: member),
  );
}

Future<void> showDeleteUserDialog({
  required Member member,
  required BuildContext context,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Member Update'),
      content: Text('${member.name}을 삭제하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            deleteMemberToFirebase(member: member);
            Navigator.pop(context, true);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

Future<void> showSignoutDialog({required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Log out'),
      content: const Text('로그아웃 하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            AuthService().signOut();
            Navigator.pop(context, true);
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}

Future<void> showUpdateBoardDialog({
  required Board board,
  required BuildContext context,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update'),
      content: const Text('수정 하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final bool result = await BoardService().updateBoard(board: board);

            if (!context.mounted) return;

            if (result) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('수정되었습니다.')));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('수정에 실패하였습니다다.')));
            }

            Navigator.pop(context, true);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> showDeleteBoardDialog({
  required Board board,
  required BuildContext context,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: const Text('삭제 하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final bool result = await BoardService().deleteBoard(board: board);

            if (!context.mounted) return;

            if (result) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('삭제에 실패하였습니다다.')));
            }

            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
