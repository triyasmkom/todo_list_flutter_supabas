import 'package:flutter/material.dart';
import 'package:todolist_app/component/app_bar_component.dart';
import 'package:todolist_app/screen/widget/menu_service_home.dart';
import 'package:todolist_app/screen/widget/menu_promo_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.phone_android_outlined, label: "Pulsa"),
    MenuItem(icon: Icons.electrical_services, label: "Listrik"),
    MenuItem(icon: Icons.wifi, label: "Paket Data"),
    MenuItem(icon: Icons.phone, label: "Telkom"),
    MenuItem(
      icon: Icons.cloud_outlined,
      label: "Cuaca",
      route: "/weather-page",
    ),
    MenuItem(icon: Icons.mosque, label: "Pray", route: "/schedule-pray"),

    MenuItem(
      icon: Icons.calendar_month_outlined,
      label: "Calendar",
      route: "/calendar",
    ),
    MenuItem(
      icon: Icons.grid_view_rounded,
      label: "Lainnya",
      type: MenuType.more,
    ),
    MenuItem(icon: Icons.menu_book, label: "Qur'an"),
    MenuItem(icon: Icons.list_alt, label: "Todos", route: "/todo"),
    MenuItem(icon: Icons.person, label: "Profile"),
    MenuItem(icon: Icons.settings, label: "Settings"),
    MenuItem(icon: Icons.money, label: "Keuangan"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MenuServiceHome(menuItems: menuItems),
            MenuPromoProduct(
              title: "Product Popular",
              viewportFraction: 0.9,
              height: 180,
              onPressed: () {},
            ),
            SizedBox(height: 12),
            MenuPromoProduct(
              title: "Rekomendasi",
              viewportFraction: 0.45,
              height: 180,
              onPressed: () {},
            ),
            SizedBox(height: 12),
            MenuPromoProduct(
              title: "Hotel",
              viewportFraction: 0.45,
              height: 180,
              onPressed: () {},
            ),
            SizedBox(height: 12),
            MenuPromoProduct(
              title: "Menu Makanan",
              viewportFraction: 0.45,
              height: 180,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuType { normal, more }

class MenuItem {
  final IconData icon;
  final String label;
  final String? route;
  final MenuType type;

  MenuItem({
    required this.icon,
    required this.label,
    this.route,
    this.type = MenuType.normal,
  });
}
