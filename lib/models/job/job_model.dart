enum JobStatus { open, closed, filled }

enum SalaryType { fixed, hourly }

class JobModel {
  final String id;
  final String serviceProviderId;
  final String jobCode;
  final String jobName;
  final String jobRole;
  final String jobDescription;
  final String companyName;
  final String location;
  final bool vehicleNeeded;
  final String? vehicleType;
  final SalaryType salaryType;
  final double salary;
  final String datePosted;
  final String timePosted;
  final String category;
  final String skill;
  final String wishlist;
  final JobStatus status;
  final String createdAt;
  final String jobOpenings;
  bool isDeleted;

  JobModel({
    required this.id,
    required this.serviceProviderId,
    required this.jobName,
    required this.jobRole,
    required this.jobDescription,
    required this.companyName,
    required this.location,
    required this.vehicleNeeded,
    this.vehicleType,
    required this.salaryType,
    required this.salary,
    required this.datePosted,
    required this.timePosted,
    required this.category,
    required this.skill,
    required this.wishlist,
    required this.status,
    required this.createdAt,
    required this.jobOpenings,
    required this.jobCode,
    this.isDeleted = false,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id']?.toString() ?? '',
      serviceProviderId: json['service_provider_id']?.toString() ?? '',
      jobCode: json['job_code'] ?? '',
      jobName: json['job_name'] ?? '',
      jobRole: json['job_role'] ?? '',
      jobDescription: json['job_description'] ?? '',
      companyName: json['company_name'] ?? '',
      location: json['location'] ?? '',
      vehicleNeeded: json['vehicle_needs']?.toLowerCase() == 'required',
      vehicleType: json['vehicle_type'],
      salaryType: _parseSalaryType(json['salary_type'] ?? ''),
      salary: double.tryParse(json['salary']?.toString() ?? '0') ?? 0.0,
      datePosted: json['job_date'] ?? '',
      timePosted: json['created_at']?.split(' ')[1] ?? '',
      category: json['category'] ?? '',
      skill: json['skill'] ?? '',
      wishlist: json['wishlist'] ?? '',
      status: _parseJobStatus(json['status']?.toString() ?? ''),
      createdAt: json['created_at'] ?? '',
      jobOpenings: json['job_openings']?.toString() ?? '0',
    );
  }

  static SalaryType _parseSalaryType(String type) {
    switch (type.toLowerCase()) {
      case 'hourly':
        return SalaryType.hourly;
      default:
        return SalaryType.fixed;
    }
  }

  static JobStatus _parseJobStatus(String status) {
    switch (status) {
      case '0':
        return JobStatus.closed;
      case '1':
        return JobStatus.open;
      case '2':
        return JobStatus.filled;
      default:
        return JobStatus.open;
    }
  }
}
