class UserModel {
  /// important
  String? uid;
  String? password;
  String? name;
  String? email;
  String? gender;

  /// additional
  String? address;
  String? phone;

  int? totalNotifications;
  int? totalNotificationsRead;

  /// pins
  String? pinnedProid;

  UserModel({
    /// important
    this.uid = "-1",
    this.password = "",
    this.name = "",
    this.email = "",
    this.gender = "0",

    /// additional
    this.address = "",
    this.phone = "",

    /// notifications
    this.totalNotifications = 0,
    this.totalNotificationsRead = 0,

    // pins
    this.pinnedProid = "-1",
  });

  // deserializing the map to class instance (Zain)
  factory UserModel.fromMap(Map data) {
    return UserModel(
      /// important
      uid: data["uid"] ?? "",
      name: data["name"] ?? "",
      email: data["email"] ?? "",
      gender: data["gender"] ?? "0",

      /// additional
      address: data["address"] ?? "",
      phone: data["phone"] ?? "",

      /// notifications
      totalNotifications: data["totalNotifications"] ?? 0,
      totalNotificationsRead: data["totalNotificationsRead"] ?? 0,

      /// pins
      pinnedProid: data["pinnedProid"] ?? "-1",
    );
  }

  /// GETTER
  Map<String, dynamic> toMap() {
    return {
      'uid': uid ?? "",
      'name': name ?? "",
      'email': email ?? "",
      'gender': gender ?? "0",
      'address': address ?? "",
      'phone': phone ?? "",
    };
  }

  Map<String, dynamic> toRequestMap() {
    return {
      'uid': uid ?? "",
      'name': name ?? "",
      'email': email ?? "",
      'phone': phone ?? "",
    };
  }

  Map<String, dynamic> toProjectRequestMap() {
    return {
      'uid': uid ?? "",
      'name': name ?? "",
      'email': email ?? "",
      'phone': phone ?? "",
    };
  }

  String? getFullName() {
    return name;
  }
}

class UserUid {
  String uid;
  bool isVerified;

  UserUid({this.uid = "-1", this.isVerified = false});
}