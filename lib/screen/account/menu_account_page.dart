import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';
import 'package:todolist_app/cubit/user_cubit.dart';
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
  late String images = '';
  late String? firstName = '';
  late String? lastName = '';

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
                route: '/profile',
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
        label: 'Registrasi Face Recognition',
        onTap: () {
          handleMenuClick(
            MenuItemCustomWidget(
              icon: Icons.face,
              label: 'Registrasi Face Recognition',
            ),
          );
        },
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.key,
        label: 'Ganti Kata Sandi',
        onTap: () {
          handleMenuClick(
            MenuItemCustomWidget(icon: Icons.logout, label: 'Ganti Kata Sandi'),
          );
        },
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.person_outline_rounded,
        label: 'Tentang',
        onTap: () {
          handleMenuClick(
            MenuItemCustomWidget(icon: Icons.logout, label: 'Tentang'),
          );
        },
      ),
      dividerWidget(),
      MenuItemCustomWidget(
        icon: Icons.logout,
        label: 'Logout',
        onTap: () {
          _logout();
          handleMenuClick(
            MenuItemCustomWidget(
              icon: Icons.logout,
              label: 'Logout',
              route: "/bottom-page",
            ),
          );
        },
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

  void _logout() {
    context.read<AuthCubit>().logout();
  }

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLogin) {
          final user = state.user;

          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background/login.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserLoaded) {
                      setState(() {
                        images = state.user['photo_url'];
                        firstName = state.user['first_name'];
                        lastName = state.user['last_name'];
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue.shade200,
                            child: CircleAvatar(
                              radius: 58,
                              backgroundImage: NetworkImage(images, scale: 0.2),
                              // Bisa ganti ke network image
                            ),
                          ),
                          gap(12),
                          Text(
                            "$firstName $lastName",
                            style: TextStyle(
                              fontFamily: "PoppinsFont",
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          gap(4),
                          Text(
                            user?.email ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "PoppinsFont",
                              color: Colors.white,
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
