import 'package:flutter_bloc/flutter_bloc.dart';

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

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void login(String username, String password, UserRole role) {
    emit(AuthState(isAuthenticated: true, role: role, username: username));
  }

  void logout() {
    emit(AuthState(isAuthenticated: false));
  }
}
