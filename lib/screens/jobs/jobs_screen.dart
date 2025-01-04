import 'package:flutter/material.dart';

import '../../controllers/jobs/jobs_controller.dart';
import '../../models/job/job_model.dart';
import '../../navigation/drawer_menu.dart';
import '../../widgets/job_box_widget.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
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
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text(
          'Jobs',
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildFilterSection(),
                const SizedBox(height: 16),
                Expanded(child: _buildJobList()),
              ],
            ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Category'),
          const SizedBox(width: 8),
          _buildFilterChip('Location'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {VoidCallback? onTap}) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {
        if (onTap != null) {
          onTap();
        } else {
          // TODO: Implement filter functionality
        }
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(color: Colors.blue[800]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue[200]!),
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
