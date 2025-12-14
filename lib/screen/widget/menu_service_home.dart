import 'package:flutter/material.dart';
import 'package:todolist_app/screen/home_menu/home_page.dart';

class MenuServiceHome extends StatelessWidget {
  final List<MenuItem> menuItems;
  const MenuServiceHome({super.key, required this.menuItems});

  void showAllMenuModal(BuildContext parentContext) {
    final allMenus = menuItems.where((e) => e.type == MenuType.normal).toList();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                'Semua Layanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                itemCount: allMenus.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final item = allMenus[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        handleMenuClick(item, parentContext);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xff5b8bdf),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item.icon, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void handleMenuClick(MenuItem item, BuildContext context) {
    if (item.type == MenuType.more) {
      showAllMenuModal(context);
      return;
    }

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
    final int maxMenu = 8;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: menuItems.length > maxMenu ? maxMenu : menuItems.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 1,
          maxCrossAxisExtent: 85,
          crossAxisSpacing: 40,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => handleMenuClick(item, context),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff5b8bdf),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 30, color: Colors.white),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
