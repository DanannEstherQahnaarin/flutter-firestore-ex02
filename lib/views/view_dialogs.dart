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

Future<void> showUpdateUserDialog({
  required Member member,
  required BuildContext context,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return UpdateUserDialog(updateMember: member);
    },
  );
}
