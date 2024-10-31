import 'package:flutter/material.dart';

Widget _buildPasswordList(BuildContext context) {
  return ListView.builder(
    itemCount: passwords.length,
    itemBuilder: (context, index) {
      final password = passwords[index];
      return Dismissible(
        key: Key(password.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          // Remove the password
        },
        child: _buildPasswordCard(context, password),
      );
    },
  );
}