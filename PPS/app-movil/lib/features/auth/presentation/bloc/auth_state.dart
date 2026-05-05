// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_token.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Estado inicial — verificando sesión existente
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Comprobando sesión o procesando login
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Usuario autenticado correctamente
class AuthAuthenticated extends AuthState {
  final AuthToken token;
  const AuthAuthenticated({required this.token});
  @override
  List<Object?> get props => [token.userId];
}

/// Sin sesión activa — mostrar pantalla de login
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error de autenticación — mostrar mensaje al usuario
class AuthError extends AuthState {
  final String message;
  final bool isCriticalSecurity; // true = cerrar app o mostrar alerta RASP
  const AuthError({required this.message, this.isCriticalSecurity = false});
  @override
  List<Object?> get props => [message, isCriticalSecurity];
}
