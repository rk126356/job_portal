enum UserType { user, provider }

extension UserTypeExtension on UserType {
  String toText() {
    switch (this) {
      case UserType.user:
        return 'User';
      case UserType.provider:
        return 'Provider';
    }
  }
}

class UserModel {
  String userId;
  String name;
  String phone;
  String email;
  String password;
  String createdAt;
  UserType userType;
  String candidatePhoto;
  String cv;
  String vehicleType;
  String vehicleRegNo;
  String vehicleRegDoc;
  String status;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.userType,
    this.candidatePhoto = '',
    this.cv = '',
    this.vehicleType = '',
    this.vehicleRegNo = '',
    this.vehicleRegDoc = '',
    this.status = '1',
  });

  // Factory method to create an instance of UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      createdAt: json['created_at'] ?? '',
      userType: _parseUserType(json['user_type']),
      candidatePhoto: json['candidate_photo'] ?? '',
      cv: json['cv'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleRegNo: json['vehicle_reg_no'] ?? '',
      vehicleRegDoc: json['vehicle_reg_doc'] ?? '',
      status: json['status'] ?? '1',
    );
  }

  // Method to convert UserModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'created_at': createdAt,
      'user_type': userType.toString().split('.').last,
      'candidate_photo': candidatePhoto,
      'cv': cv,
      'vehicle_type': vehicleType,
      'vehicle_reg_no': vehicleRegNo,
      'vehicle_reg_doc': vehicleRegDoc,
      'status': status,
    };
  }

  // Helper method to parse UserType from string
  static UserType _parseUserType(String? userType) {
    switch (userType) {
      case 'user':
        return UserType.user;
      case 'provider':
        return UserType.provider;
      default:
        return UserType.user;
    }
  }
}
