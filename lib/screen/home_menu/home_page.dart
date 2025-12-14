import 'package:flutter/material.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_MenuItem> menuItems = [
    _MenuItem(icon: Icons.list_alt, label: "Todos", route: "/todo"),
    _MenuItem(icon: Icons.person, label: "Profile"),
    _MenuItem(icon: Icons.settings, label: "Settings"),
    _MenuItem(icon: Icons.money, label: "Keuangan"),
    _MenuItem(
      icon: Icons.cloud_outlined,
      label: "Cuaca",
      route: "/weather-page",
    ),
    _MenuItem(icon: Icons.mosque, label: "Pray", route: "/schedule-pray"),
    _MenuItem(icon: Icons.menu_book, label: "Qur'an"),
    _MenuItem(
      icon: Icons.calendar_month_outlined,
      label: "Calendar",
      route: "/calendar",
    ),
  ];

  void handleMenuClick(_MenuItem item) {
    if (item.route == null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Informasi'),
              content: Text('Fitur ${item.label} belum tersedia'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Jika ada rute
    Navigator.pushNamed(context, item.route!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => handleMenuClick(item),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 40, color: Colors.blue),
                    gap(10),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? route;

  _MenuItem({required this.icon, required this.label, this.route});
}
