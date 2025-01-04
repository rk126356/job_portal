// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:job_portal/screens/auth/register_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/colors.dart';
import '../../providers/user_provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    provider.userData.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  accountEmail: Text(
                    provider.userData.phone,
                  ),
                  currentAccountPicture: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-Ne7oVV6Lx9uAnmJDUZrrLcGy8yzo1sXdpQ&usqp=CAU'),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'Profile',
                  ),
                  onTap: () {},
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.group_outlined,
                //     color: AppColors.primaryColor,
                //   ),
                //   title: const Text(
                //     'Students',
                //   ),
                //   onTap: () {},
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.assignment_turned_in_outlined,
                //     color: AppColors.primaryColor,
                //   ),
                //   title: const Text(
                //     'Attendances',
                //   ),
                //   onTap: () {},
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.currency_rupee,
                //     color: AppColors.primaryColor,
                //   ),
                //   title: const Text(
                //     'Fees Collection',
                //   ),
                //   onTap: () {},
                // ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.history,
                //     color: AppColors.primaryColor,
                //   ),
                //   title: const Text(
                //     'History',
                //   ),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'About',
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.support_agent_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'Contact',
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'Settings',
                  ),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.handshake_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'T&C',
                  ),
                  onTap: () {
                    // showTermsPopup(context, 'terms');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.book_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: const Text(
                    'Privacy Policy',
                  ),
                  onTap: () {
                    // showTermsPopup(context, 'policy');
                  },
                ),
                const Divider(),
                ListTile(
                  leading:
                      Icon(Icons.exit_to_app, color: AppColors.primaryColor),
                  title: const Text(
                    "Logout",
                  ),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
            Positioned(
              top: 30.0,
              right: 16.0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterLoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
