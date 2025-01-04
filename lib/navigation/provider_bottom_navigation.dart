import 'package:flutter/material.dart';
import 'package:job_portal/screens/dashboard/dashboard_screen.dart';
import 'package:job_portal/screens/home/home_screen.dart';
import 'package:job_portal/screens/home/provider_home_screen.dart';
import 'package:job_portal/screens/jobs/jobs_screen.dart';
import 'package:job_portal/screens/jobs/provider_my_jobs_screen.dart';

class ProviderBottomNavigation extends StatefulWidget {
  const ProviderBottomNavigation({super.key, this.initialIndex = 0});

  final int? initialIndex;

  @override
  State<ProviderBottomNavigation> createState() =>
      _ProviderBottomNavigationState();
}

class _ProviderBottomNavigationState extends State<ProviderBottomNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ProviderHomeScreen(),
    ProviderMyJobsScreen(),
    DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.initialIndex);
    if (widget.initialIndex != null) {
      _selectedIndex = widget.initialIndex ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.blue.shade400,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
