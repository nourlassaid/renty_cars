import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryTab({required this.label, required this.icon, required bool isSelected, required void Function() onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
      ],
    );
  }
}
