import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/screens/auth/account_setup_screen.dart';
import 'package:job_portal/screens/auth/provider_account_setup_screen.dart';
import 'package:job_portal/screens/profile/add_skills_screen.dart';
import 'package:job_portal/screens/profile/bookmarked_jobs_screen.dart';
import 'package:job_portal/screens/profile/edit_profile_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:provider/provider.dart';
import '../../navigation/bottom_navigation.dart';
import '../../navigation/drawer_menu.dart';
import '../../navigation/provider_bottom_navigation.dart';
import '../../providers/user_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.blue[50],
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(provider),
            _buildActionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      margin: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      color: Colors.blue[100],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    provider.userData.name ?? "User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.person, size: 35, color: Colors.blue.shade800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList() {
    final provider = Provider.of<UserProvider>(context);
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionItem(Icons.edit, 'Edit Profile', () {
            push(
                context,
                EditProfileScreen(
                  user: provider.userData,
                ));
          }),
          _buildDivider(),
          if (isUser)
            _buildActionItem(Icons.check_box, 'Applied Jobs', () {
              // TODO: Navigate to Edit Profile screen
            }),
          if (isProvider)
            _buildActionItem(Icons.check_box, 'My Jobs', () {
              pushReplace(
                  context,
                  const ProviderBottomNavigation(
                    initialIndex: 1,
                  ));
            }),
          if (isUser) _buildDivider(),
          if (isUser)
            _buildActionItem(Icons.bookmark, 'Bookmarked Jobs', () {
              push(context, const BookmarkedJobsScreen());
            }),
          _buildDivider(),
          _buildActionItem(Icons.update, 'Update Details', () {
            push(
                context,
                isProvider
                    ? const ProviderAccountSetupScreen()
                    : const AccountSetupScreen());
          }),
          _buildDivider(),
          if (isUser)
            _buildActionItem(Icons.work, 'Update Skills', () {
              push(context, const AddSkillsScreen());
            }),
          _buildDivider(),
          _buildActionItem(Icons.settings, 'Settings', () {
            // TODO: Navigate to Settings screen
          }),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade800),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      height: 1,
      thickness: 1,
    );
  }
}
