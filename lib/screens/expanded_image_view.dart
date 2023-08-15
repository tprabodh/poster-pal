import 'package:flutter/material.dart';


class ExpandedImageView extends StatelessWidget {
  final String imageUrl;

  const ExpandedImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
