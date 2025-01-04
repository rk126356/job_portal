import 'package:flutter/material.dart';
import 'package:job_portal/const/url.dart';
import 'package:job_portal/controllers/basic/get_post_api.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/providers/user_provider.dart';
import 'package:job_portal/screens/jobs/see_applications_screeen.dart';
import 'package:job_portal/utils/basic/extentions.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';
import 'package:job_portal/utils/basic/toast.dart';
import 'package:job_portal/widgets/tools_widgets.dart';

class InsideJobScreen extends StatefulWidget {
  final JobModel job;
  final bool isProvider;

  const InsideJobScreen(
      {super.key, required this.job, required this.isProvider});

  @override
  State<InsideJobScreen> createState() => _InsideJobScreenState();
}

class _InsideJobScreenState extends State<InsideJobScreen> {
  bool _isButtonLoading = false;
  bool _isBookmarked = false;
  bool _isApplied = false;

  void _applyJob() async {
    if (_isApplied) {
      showError('Already applied for this job');
      return;
    }
    setState(() {
      _isButtonLoading = true;
    });
    final data = await postApi(
      url: '$userBaseUrl/apply_job.php',
      body: {
        'job_id': widget.job.id,
        'user_id': globalUserId,
      },
      showPopup: true,
    );
    if (data != null) {
      print(data);
      _isApplied = true;
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  void _bookmarkJob() async {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    final data = await postApi(
      url: '$userBaseUrl/bookmark_job.php',
      body: {
        'job_id': widget.job.id,
        'user_id': globalUserId,
      },
      showPopup: true,
    );
    if (data != null) {
      print(data);
    }
  }

  void _removeBookmarkJob() async {
    setState(() {
      _isBookmarked = false;
    });
    final data = await postApi(
      url: '$userBaseUrl/remove_bookmark.php',
      body: {
        'job_id': widget.job.id,
        'user_id': globalUserId,
      },
      showPopup: true,
    );
    if (data != null) {
      print(data);
    }
  }

  void _deleteJob() async {
    setState(() {
      _isButtonLoading = true;
    });
    final data = await postApi(
      url: '$providerBaseUrl/delete_job.php',
      body: {
        'job_id': widget.job.id,
        'user_id': globalUserId,
      },
      showPopup: true,
    );
    if (data != null) {
      Navigator.pop(context);
      widget.job.isDeleted = true;
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        title: const Text(
          'Job Details',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: widget.job.isDeleted
            ? null
            : [
                if (_isButtonLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                else if (widget.isProvider) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement bookmark functionality
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () async {
                      bool? isOk = await showConfirmDialog(
                          context: context, title: 'Dete Job?');
                      if (isOk ?? false) {
                        _deleteJob();
                      }
                    },
                  ),
                ] else
                  IconButton(
                    icon: Icon(
                        _isBookmarked
                            ? Icons.bookmark_added
                            : Icons.bookmark_border,
                        color: Colors.white),
                    onPressed:
                        _isBookmarked ? _removeBookmarkJob : _bookmarkJob,
                  ),
              ],
      ),
      body: widget.job.isDeleted
          ? const CustomErrorBox(
              text: 'Job has been deleted',
              showBackButton: true,
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(context),
                        _buildContent(context),
                      ],
                    ),
                  ),
                ),
                _buildApplyButton()
              ],
            ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJobCard(),
        _buildJobDetails(),
        _buildJobDescription(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade800, Colors.blue.shade500],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.job.jobRole,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job.companyName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
          _buildInfoRow(Icons.location_on, widget.job.location),
          _buildInfoRow(Icons.access_time, widget.job.datePosted),
          _buildInfoRow(
            Icons.attach_money,
            '${widget.job.salaryType == SalaryType.fixed ? 'Fixed' : 'Hourly'}: \$${widget.job.salary}',
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Category', widget.job.category),
          _buildDetailRow('Skill', widget.job.skill),
          _buildDetailRow('Date', widget.job.datePosted),
          _buildDetailRow('Status', widget.job.status.name.toCapitalize()),
          if (widget.job.vehicleNeeded)
            _buildDetailRow('Vehicle Needed', widget.job.vehicleType ?? 'Yes'),
        ],
      ),
    );
  }

  Widget _buildJobDescription() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Job Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            widget.job.jobDescription,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ElevatedButton(
        onPressed: _isButtonLoading
            ? null
            : widget.isProvider
                ? () => push(context, SeeApplicationsScreeen(job: widget.job))
                : _applyJob,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            _isApplied
                ? 'Applied'
                : _isButtonLoading
                    ? 'Applying...'
                    : widget.isProvider
                        ? 'See Applications'
                        : 'Apply Now',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
