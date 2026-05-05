// lib/features/auth/presentation/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  // SEGURIDAD: No incluir 'password' en props (Equatable lo usa para toString/==)
  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckSession extends AuthEvent {
  const AuthCheckSession();
}

class AuthBiometricRequested extends AuthEvent {
  const AuthBiometricRequested();
}
