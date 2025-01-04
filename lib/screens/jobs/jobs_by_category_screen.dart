import 'package:flutter/material.dart';
import 'package:job_portal/widgets/tools_widgets.dart';

import '../../const/url.dart';
import '../../controllers/basic/get_post_api.dart';
import '../../models/job/job_model.dart';
import '../../widgets/job_box_widget.dart';

class JobsByCategoryScreen extends StatefulWidget {
  const JobsByCategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<JobsByCategoryScreen> createState() => _JobsByCategoryScreenState();
}

class _JobsByCategoryScreenState extends State<JobsByCategoryScreen> {
  List<JobModel> _jobs = [];
  bool _isLoading = false;

  void _load(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await postApi(
        url: '$userBaseUrl/fetch_filtered_jobs.php',
        body: {'category': query},
        shouldPrint: true,
      );

      if (response != null) {
        _jobs = (response['data'] as List)
            .map((jobData) => JobModel.fromJson(jobData))
            .toList();
      } else {
        _jobs = [];
      }
    } catch (e) {
      print('Exception occurred: $e');
      _jobs = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          '${widget.category} Jobs',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {
          //     // TODO: Implement search functionality
          //   },
          // ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _jobs.isEmpty
              ? const CustomErrorBox(text: 'No jobs found!')
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
