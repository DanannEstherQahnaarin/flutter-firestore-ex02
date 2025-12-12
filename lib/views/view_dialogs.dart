import 'package:flutter/material.dart';
import 'package:flutter_application_mms/models/member.dart';
import 'package:flutter_application_mms/views/view_member_add.dart';
import 'package:flutter_application_mms/views/view_member_update.dart';

Future<void> showAddUserDialog({required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const AddUserDialog();
    },
  );
}

Future<void> showUpdateUserDialog({required Member member, required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return UpdateUserDialog(updateMember: member);
    },
  );
}

Future<void> showDeleteUserDialog({required Member member, required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Member Update'),
      content: Text('${member.name}을 삭제하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Cancel'),
        ),
      ],
    ),
  );
}
