import 'package:flutter/material.dart';

class VotingOptionTile extends StatelessWidget {
  final String optionText;
  final VoidCallback onTap;

  const VotingOptionTile({super.key, required this.optionText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(optionText),
      onTap: onTap,
    );
  }
}
