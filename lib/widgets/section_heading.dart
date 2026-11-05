import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  final String subtitle;
  final String title;

  const SectionHeading({
    super.key,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFFB94E68),
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF55342F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFD9879A),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
