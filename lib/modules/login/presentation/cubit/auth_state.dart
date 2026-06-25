part of 'auth_cubit.dart';

enum UserRole { admin, user }

class AuthState {
  final bool isAuthenticated;
  final UserRole? role;
  final String? username;

  AuthState({this.isAuthenticated = false, this.role, this.username});

  AuthState copyWith({
    bool? isAuthenticated,
    UserRole? role,
    String? username,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      username: username ?? this.username,
    );
  }
}
