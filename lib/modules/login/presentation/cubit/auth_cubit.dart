import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void login(String username, String password, UserRole role) {
    emit(AuthState(isAuthenticated: true, role: role, username: username));
  }

  void logout() {
    emit(AuthState(isAuthenticated: false));
  }
}
