import 'package:flutter/material.dart';
import 'package:job_portal/models/job/job_model.dart';
import 'package:job_portal/screens/jobs/inside_job_screen.dart';
import 'package:job_portal/utils/basic/extentions.dart';
import 'package:job_portal/utils/basic/navigate_tool.dart';

class JobBoxWidget extends StatelessWidget {
  final JobModel job;
  final bool isProvider;

  const JobBoxWidget({super.key, required this.job, this.isProvider = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        push(
            context,
            InsideJobScreen(
              job: job,
              isProvider: isProvider,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.jobRole,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('Openings: ${job.jobOpenings}'),
                  // Icon(
                  //   job. ? Icons.favorite : Icons.favorite_border,
                  //   color: job.isWishlisted ? Colors.red : Colors.grey,
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              if (!isProvider) ...[
                Text(
                  job.companyName,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (isProvider) ...[
                Text(
                  job.status.name.toCapitalize(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    job.location,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '${job.salaryType == SalaryType.fixed ? 'Annual' : 'Hourly'}: \$${job.salary}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
