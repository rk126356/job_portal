import 'package:flutter/material.dart';
import 'package:job_portal/screens/dashboard/dashboard_screen.dart';
import 'package:job_portal/screens/home/home_screen.dart';
import 'package:job_portal/screens/jobs/jobs_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, this.initialIndex = 0});

  final int? initialIndex;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    JobsScreen(),
    DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
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
            label: 'Jobs',
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
