import 'package:flutter/material.dart';
import 'package:flutter_application_mms/views/view_user_add.dart';

Future<void> showAddUserDialog({required BuildContext context}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const AddUserDialog();
    },
  );
}
