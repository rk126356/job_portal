import 'package:flutter/material.dart';
import 'package:job_portal/screens/jobs/post_job_screen.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/widgets/tools_widgets.dart';

import '../../controllers/jobs/jobs_controller.dart';
import '../../models/job/job_model.dart';
import '../../navigation/drawer_menu.dart';
import '../../widgets/job_box_widget.dart';

class ProviderMyJobsScreen extends StatefulWidget {
  const ProviderMyJobsScreen({super.key});

  @override
  State<ProviderMyJobsScreen> createState() => _ProviderMyJobsScreenState();
}

class _ProviderMyJobsScreenState extends State<ProviderMyJobsScreen> {
  List<JobModel> _jobs = [];
  bool _isLoading = false;

  Future<void> _loadJobs() async {
    _jobs = await getPostedJobs();
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
          'My Jobs',
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
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, const PostJobScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _jobs.isEmpty
              ? const CustomErrorBox(text: 'No jobs posted yet!')
              : RefreshIndicator(
                  onRefresh: () async {
                    _load();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Expanded(child: _buildJobList()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildJobList() {
    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return JobBoxWidget(
          job: job,
          isProvider: true,
        );
      },
    );
  }
}
