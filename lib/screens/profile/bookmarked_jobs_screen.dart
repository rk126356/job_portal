import 'package:flutter/material.dart';

import '../../controllers/jobs/jobs_controller.dart';
import '../../models/job/job_model.dart';
import '../../navigation/drawer_menu.dart';
import '../../widgets/job_box_widget.dart';

class BookmarkedJobsScreen extends StatefulWidget {
  const BookmarkedJobsScreen({super.key});

  @override
  State<BookmarkedJobsScreen> createState() => _BookmarkedJobsScreenState();
}

class _BookmarkedJobsScreenState extends State<BookmarkedJobsScreen> {
  List<JobModel> _jobs = [];
  bool _isLoading = false;

  Future<void> _loadJobs() async {
    _jobs = await getJobs();
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
      appBar: AppBar(
        title: const Text(
          'Bookmarked Jobs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(child: _buildJobList()),
              ],
            ),
    );
  }

  Widget _buildJobList() {
    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return JobBoxWidget(job: job);
      },
    );
  }
}
