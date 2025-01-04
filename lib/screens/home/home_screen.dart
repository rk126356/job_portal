import 'package:flutter/material.dart';
import 'package:job_portal/controllers/jobs/jobs_controller.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/models/user/user_model.dart';
import 'package:job_portal/navigation/drawer_menu.dart';
import 'package:job_portal/screens/jobs/jobs_by_category_screen.dart';
import 'package:job_portal/screens/jobs/search_job_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/job_box_widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/basic/extra.dart';
import '../../controllers/user/user_controller.dart';
import '../../models/basic/category_model.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<CategoryModel> _categories = [];
  List<JobModel> _jobs = [];

  Future<void> _loadUser() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    UserModel? user = await getUser(globalUserId);
    if (user != null) {
      provider.setUserData(user);
    }
  }

  Future<void> _loadJobs() async {
    _jobs = await getRecentJobs();
  }

  Future<void> _loadCategories() async {
    _categories = await getCategories();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    await _loadUser();
    await _loadJobs();
    await _loadCategories();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text(
          'Gigable',
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
            icon: const Icon(Icons.search),
            onPressed: () {
              push(context, const SearchJobScreen());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildCategorySlider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Recent Jobs',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement navigation to the full job list screen
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildJobList(),
                ],
              ),
            ),
    );
  }

  Widget _buildCategorySlider() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _buildCategoryBox(
            category.categoryName,
            _getCategoryGradient(index),
          );
        },
      ),
    );
  }

  Widget _buildCategoryBox(String title, LinearGradient gradient) {
    return GestureDetector(
      onTap: () {
        push(context, JobsByCategoryScreen(category: title));
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: gradient,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  LinearGradient _getCategoryGradient(int index) {
    final gradients = [
      LinearGradient(
        colors: [Colors.purple.shade800, Colors.purple.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Colors.green.shade800, Colors.green.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Colors.orange.shade800, Colors.orange.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Colors.red.shade800, Colors.red.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    return gradients[index % gradients.length];
  }

  Widget _buildJobList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return JobBoxWidget(job: job);
      },
    );
  }
}
