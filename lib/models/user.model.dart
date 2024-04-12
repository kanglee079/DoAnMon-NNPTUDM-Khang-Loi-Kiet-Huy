class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? address;
  final String? fullname;
  final String? avatar;
  String status;
  final int ordering;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.address,
    this.fullname,
    this.avatar,
    required this.status,
    required this.ordering,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String?,
      fullname: json['fullname'] as String?,
      avatar: json['avatar'] as String?,
      status: json['status'] as String? ?? 'active',
      ordering: json['ordering'] as int? ?? 0,
      role: json['role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone': phone,
        'address': address,
        'fullname': fullname,
        'avatar': avatar,
        'status': status,
        'ordering': ordering,
        'role': role,
      };
}
