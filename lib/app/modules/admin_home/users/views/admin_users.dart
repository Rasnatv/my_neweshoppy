class AdminUser {
  final String username;
  final String password;
  final String role;

  AdminUser({
    required this.username,
    required this.password,
    required this.role,
  });
}

class AdminUsersDB {
  static List<AdminUser> adminUsers = [
    AdminUser(username: "superadmin", password: "123456", role: "superadmin"),
    AdminUser(username: "state01", password: "111111", role: "state_admin"),
    AdminUser(username: "district01", password: "222222", role: "district_admin"),
    AdminUser(username: "area01", password: "333333", role: "area_admin"),
  ];

  /// Validate login offline
  static AdminUser? login(String username, String password) {
    try {
      return adminUsers.firstWhere(
            (user) =>
        user.username == username.trim() &&
            user.password == password.trim(),
      );
    } catch (e) {
      return null;
    }
  }
}
