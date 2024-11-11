import 'package:flutter/material.dart';

class MyBusinessContainerRounded extends StatelessWidget {
  const MyBusinessContainerRounded(
      {super.key, required this.name, required this.imageLink});
  final String name;
  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            foregroundImage: NetworkImage(imageLink),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
          ),
        ],
      ),
    );
  }
}
