import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/job/application_model.dart';

Future<bool?> showApplicationDetails(
    BuildContext context, ApplicationModel application) async {
  return await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(context, application),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDetailSection(application),
                      const SizedBox(height: 24),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildHeader(BuildContext context, ApplicationModel application) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade800, Colors.blue.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Row(
      children: [
        buildAvatar(application),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                application.candidateName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Applied on ${formatDate(application.createdAt)}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Widget _buildDetailSection(ApplicationModel application) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDetailItem(
        Icons.description,
        'CV',
        application.cv.isEmpty
            ? 'Not Added'
            : Row(
                children: [
                  const Text('View'),
                  const SizedBox(width: 5),
                  Icon(Icons.remove_red_eye,
                      color: Colors.blue.shade800, size: 20),
                ],
              ),
      ),
      if (application.vehicleType == 'required') ...[
        _buildDetailItem(
            Icons.directions_car, 'Vehicle Type', application.vehicleType),
        _buildDetailItem(Icons.pin, 'Vehicle Reg No', application.vehicleRegNo),
        _buildDetailItem(
          Icons.file_present,
          'Vehicle Doc',
          application.vehicleRegDoc.isEmpty
              ? 'Not Added'
              : Row(
                  children: [
                    const Text('View'),
                    const SizedBox(width: 5),
                    Icon(Icons.remove_red_eye,
                        color: Colors.blue.shade800, size: 20),
                  ],
                ),
        ),
      ] else
        _buildDetailItem(Icons.directions_car, 'Vehicle', 'Not Added/Required'),
    ],
  );
}

Widget _buildDetailItem(IconData icon, String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue.shade800, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              value is Widget
                  ? value
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButtons(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check),
          label: const Text('Approve'),
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Reject'),
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    ],
  );
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
}

Widget buildAvatar(ApplicationModel application) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.blue.shade800, width: 2),
    ),
    child: application.candidatePhoto.isNotEmpty
        ? ClipOval(
            child: Image.network(
              application.candidatePhoto,
              fit: BoxFit.cover,
            ),
          )
        : CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            child: Text(
              application.candidateName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
  );
}
