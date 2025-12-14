import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_app/cubit/auth_cubit.dart';

class AppBarComponent extends AppBar {
  AppBarComponent()
    : super(
        elevation: 0.25,
        toolbarHeight: 160,
        backgroundColor: Colors.white,
        flexibleSpace: _buildAppBar(),
      );

  static Widget _buildAppBar() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLogin) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 8, 16, 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6a8aff), Color(0xffb2fbff)],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                "assets/no_image.jpeg",
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WELCOME",
                                  style: TextStyle(
                                    fontFamily: "PoppinsFont",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Dona Stroupe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsFont",
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.notifications),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        Container(height: 16),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Color(0xff5b8bdf),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Rp 100.000.000",
                            style: TextStyle(
                              fontFamily: "UbuntuFont",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 50),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 8, 16, 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6a8aff), Color(0xffb2fbff)],
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        }
      },
    );
  }
}
