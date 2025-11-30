import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/screen/auth/sign_in_page.dart';
import 'package:todolist_app/screen/widget/custom_widged.dart';
import 'package:todolist_app/screen/widget/divider_widget.dart';
import 'package:todolist_app/screen/widget/menu_item_custom_widget.dart';

class MenuAccountPage extends StatefulWidget {
  const MenuAccountPage({super.key});

  @override
  State<MenuAccountPage> createState() => _MenuAccountPageState();
}

class _MenuAccountPageState extends State<MenuAccountPage> {
  List<Widget> _menuItems() {
    return [
      MenuItemCustomWidget(
        icon: Icons.account_balance_wallet,
        label: 'Saldo',
        route: null,
        onTap:
            () => handleMenuClick(
              MenuItemCustomWidget(
                icon: Icons.account_balance_wallet,
                label: 'Saldo',
              ),
            ),
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.person_outline,
        label: 'Profil Saya',
        route: null,
        onTap:
            () => handleMenuClick(
              MenuItemCustomWidget(
                icon: Icons.person_outline,
                label: 'Profil Saya',
              ),
            ),
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.miscellaneous_services,
        label: 'Layanan Saya',
        onTap:
            () => handleMenuClick(
              MenuItemCustomWidget(
                icon: Icons.miscellaneous_services,
                label: 'Layanan Saya',
              ),
            ),
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.history,
        label: 'Daftar Riwayat',
        onTap:
            () => handleMenuClick(
              MenuItemCustomWidget(
                icon: Icons.history,
                label: 'Daftar Riwayat',
              ),
            ),
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.logout,
        label: 'Logout',
        onTap:
            () => handleMenuClick(
              MenuItemCustomWidget(icon: Icons.logout, label: 'Logout'),
            ),
      ),
    ];
  }

  /// Handler utama
  void handleMenuClick(MenuItemCustomWidget item) {
    if (item.route == null) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Informasi'),
              content: Text('Fitur "${item.label}" belum tersedia'),
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

    Navigator.pushNamed(context, item.route!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // if (state is AuthLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        if (state is AuthLogin) {
          final user = state.user;
          final meta = user?.userMetadata ?? {};
          final firstName = meta['first_name'] ?? '';
          final lastName = meta['last_name'] ?? '';

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue.shade200,
                        child: const CircleAvatar(
                          radius: 42,
                          backgroundImage: AssetImage("assets/profile.jpg"),
                          // Bisa ganti ke network image
                        ),
                      ),
                      gap(12),
                      Text(
                        "$firstName $lastName",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      gap(4),
                      Text(
                        user?.email ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  gap(25),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Column(children: _menuItems()),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SignInPage();
        }
      },
    );
  }
}
