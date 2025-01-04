import 'package:flutter/material.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/providers/user_provider.dart';
import '../../models/job/application_model.dart';
import 'package:intl/intl.dart';

import '../../utils/popup/application_popup.dart'; // Add this import at the top of the file

class SeeApplicationsScreeen extends StatefulWidget {
  const SeeApplicationsScreeen({super.key, required this.job});
  final JobModel job;

  @override
  State<SeeApplicationsScreeen> createState() => _SeeApplicationsScreeenState();
}

class _SeeApplicationsScreeenState extends State<SeeApplicationsScreeen> {
  List<ApplicationModel> _applications = [];
  bool _isLoading = true;

  void _loadApplications() async {
    setState(() {
      _isLoading = true;
    });

    final data = await postApi(
        url: '$providerBaseUrl/get_applications_for_job.php',
        body: {
          'job_id': widget.job.id,
          'user_id': globalUserId,
        });
    if (data != null) {
      List<dynamic> jsonApplications = data['data'];
      _applications = jsonApplications
          .map((json) => ApplicationModel.fromJson(json))
          .toList();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Applications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: _loadApplications, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildApplicationsList(),
    );
  }

  Widget _buildApplicationsList() {
    return _applications.isEmpty
        ? const Center(child: Text('No applications yet.'))
        : ListView.builder(
            itemCount: _applications.length,
            itemBuilder: (context, index) {
              final application = _applications[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    bool? result =
                        await showApplicationDetails(context, application);
                    if (result == true) {
                      // Application was approved
                      print('Application approved');
                    } else if (result == false) {
                      // Application was rejected
                      print('Application rejected');
                    } else {
                      // Modal was closed without approval or rejection
                      print('Modal was closed');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAvatar(application),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                application.candidateName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Applied on: ${formatDate(application.createdAt)}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    application.cv.isEmpty
                                        ? Icons.close
                                        : Icons.check,
                                    color: application.cv.isEmpty
                                        ? Colors.red
                                        : Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'CV ${application.cv.isEmpty ? 'Not Added' : 'Added'}',
                                    style: TextStyle(
                                      color: application.cv.isEmpty
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.blue.shade800,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
