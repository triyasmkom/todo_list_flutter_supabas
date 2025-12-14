import 'package:flutter/material.dart';

class MenuItemCustomWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? route;
  final VoidCallback? onTap; // dipanggil parent

  const MenuItemCustomWidget({
    super.key,
    required this.icon,
    required this.label,
    this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: "PoppinsFont",
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
