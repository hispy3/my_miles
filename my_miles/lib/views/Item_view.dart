import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemView extends StatelessWidget {
  final String title, value;

  const ItemView({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(title,
                    style: const TextStyle(
                      fontSize: 14,
                    ))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(
                      fontSize: 14,
                    ))),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
