import 'package:flutter/material.dart';

class UsernameTextField extends StatefulWidget {
  final bool enable;
  final VoidCallback onChanged;

  const UsernameTextField({Key? key, required this.enable, required this.onChanged}) : super(key: key);

  @override
  UsernameTextFieldState createState() => UsernameTextFieldState();
}

class UsernameTextFieldState extends State<UsernameTextField> {
  TextEditingController textControllerUsername = TextEditingController();
  FocusNode focusNode = FocusNode();

  void setUsername(String username) {
    textControllerUsername.text = username;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Row(
        children: <Widget>[
          const Icon(Icons.account_box),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              enabled: widget.enable,
              decoration: const InputDecoration(hintText: 'שם משתמש / ת.ז'),
              controller: textControllerUsername,
              onChanged: (s) {
                widget.onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}
