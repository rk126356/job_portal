class ApplicationModel {
  final String id;
  final String jobId;
  final String userId;
  final String serviceProviderId;
  final String candidateName;
  final String candidatePhoto;
  final String cv;
  final String vehicleType;
  final String vehicleRegNo;
  final String vehicleRegDoc;
  final String status;
  final String createdAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.serviceProviderId,
    required this.candidateName,
    required this.candidatePhoto,
    required this.cv,
    required this.vehicleType,
    required this.vehicleRegNo,
    required this.vehicleRegDoc,
    required this.status,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? '',
      jobId: json['job_id'] ?? '',
      userId: json['user_id'] ?? '',
      serviceProviderId: json['service_provider_id'] ?? '',
      candidateName: json['candidate_name'] ?? 'No Name Provided',
      candidatePhoto: json['candidate_photo'] ?? '',
      cv: json['cv'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleRegNo: json['vehicle_reg_no'] ?? '',
      vehicleRegDoc: json['vehicle_reg_doc'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'user_id': userId,
      'service_provider_id': serviceProviderId,
      'candidate_name': candidateName,
      'candidate_photo': candidatePhoto,
      'cv': cv,
      'vehicle_type': vehicleType,
      'vehicle_reg_no': vehicleRegNo,
      'vehicle_reg_doc': vehicleRegDoc,
      'status': status,
      'created_at': createdAt,
    };
  }
}
