import 'package:flutter/material.dart';

class MenuPromoProduct extends StatefulWidget {
  final String title;
  final double viewportFraction;
  final double height;
  final VoidCallback onPressed;
  const MenuPromoProduct({
    super.key,
    required this.viewportFraction,
    required this.height,
    required this.title,
    required this.onPressed,
  });

  @override
  State<MenuPromoProduct> createState() => _MenuPromoProductState();
}

class _MenuPromoProductState extends State<MenuPromoProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "PoppinsFont",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: widget.onPressed,
                ),
              ],
            ),
          ),
          _buildCardSwipeHorizontal(widget.height, widget.viewportFraction),
        ],
      ),
    );
  }
}

Widget _buildCardSwipeHorizontal(double height, double viewportFraction) {
  return SizedBox(
    height: height,
    child: PageView.builder(
      controller: PageController(viewportFraction: viewportFraction),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6a8aff), Color(0xffb2fbff)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text("Card ${index + 1}")),
            ),
          ),
        );
      },
    ),
  );
}
