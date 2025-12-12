import 'package:flutter/material.dart';
import 'package:flutter_application_mms/views/view_member_add.dart';

Future<void> showAddUserDialog({required BuildContext context}) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const AddUserDialog();
    },
  );
}
