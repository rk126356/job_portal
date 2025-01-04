import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/navigation/provider_bottom_navigation.dart';
import 'package:job_portal/screens/jobs/inside_job_screen.dart';
import 'package:job_portal/utils/basic/extentions.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:provider/provider.dart';

import '../../controllers/jobs/jobs_controller.dart';
import '../../models/job/job_model.dart';
import '../../navigation/drawer_menu.dart';
import '../../providers/user_provider.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  List<JobModel> jobs = [];
  bool _isLoading = false;

  Future<void> _loadJobs() async {
    jobs = await getPostedJobs();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });
    await _loadJobs();
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
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildJobStats()),
                SliverToBoxAdapter(child: _buildRecentJobs(jobs)),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    final provider = Provider.of<UserProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[700],
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                provider.userData.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Active Jobs', '0', Icons.work)),
          const SizedBox(width: 20),
          Expanded(child: _buildStatCard('Completed', '0', Icons.check_circle)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJobs(List<JobModel> jobs) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Jobs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          if (jobs.isEmpty)
            const Text(
              'No recent jobs found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          else
            ...jobs.take(5).map((job) => _buildJobCard(job)),
          if (jobs.length > 5)
            TextButton(
              onPressed: () {
                push(
                    context,
                    const ProviderBottomNavigation(
                      initialIndex: 1,
                    ));
              },
              child: Text(
                'View all ${jobs.length} jobs',
                style: TextStyle(color: Colors.blue[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return InkWell(
      onTap: () =>
          push(context, InsideJobScreen(job: job, isProvider: isProvider)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getStatusColor(job.status.name).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.work, color: _getStatusColor(job.status.name)),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.jobName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      job.status.name.toCapitalize(),
                      style: TextStyle(
                          color: _getStatusColor(job.status.name),
                          fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
