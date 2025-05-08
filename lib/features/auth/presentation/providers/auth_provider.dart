// Importaciones necesarias para el manejo de estado, repositorios y servicios.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop_app/features/auth/domain/domain.dart';
import 'package:teslo_shop_app/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop_app/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop_app/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

// Proveedor de estado para manejar la autenticación usando Riverpod.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Instancias de repositorio y servicio de almacenamiento clave-valor.
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  // Retorna el notificador de estado con las dependencias necesarias.
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

// Clase que extiende StateNotifier para manejar el estado de autenticación.
class AuthNotifier extends StateNotifier<AuthState> {
  // Dependencias necesarias para la autenticación.
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  // Constructor que inicializa las dependencias y verifica el estado de autenticación.
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  // Método para iniciar sesión con email y contraseña.
  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula un retraso.

    try {
      // Intenta iniciar sesión y establece el usuario autenticado.
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      // Maneja errores personalizados y cierra sesión con un mensaje de error.
      logout(e.message);
    } catch (e) {
      // Maneja errores no controlados.
      logout('Error no controlado');
    }
  }

  // Método para registrar un nuevo usuario (aún no implementado).
  void registerUser(String email, String password) async {
    // ...implementación pendiente...
  }

  // Método para verificar el estado de autenticación al iniciar la app.
  void checkAuthStatus() async {
    // Obtiene el token almacenado localmente.
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout(); // Si no hay token, cierra sesión.

    try {
      // Verifica el estado de autenticación con el token.
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      // Si ocurre un error, cierra sesión.
      logout();
    }
  }

  // Método privado para establecer el usuario autenticado y actualizar el estado.
  void _setLoggedUser(User user) async {
    // Almacena el token del usuario en el almacenamiento local.
    await keyValueStorageService.setKeyValue('token', user.token);

    // Actualiza el estado con el usuario autenticado.
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  // Método para cerrar sesión y limpiar el estado.
  Future<void> logout([String? errorMessage]) async {
    // Elimina el token almacenado localmente.
    await keyValueStorageService.removeKey('token');

    // Actualiza el estado a no autenticado y opcionalmente establece un mensaje de error.
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

// Primera parte de la implementación de la clase AuthState y AuthStaus
// Enumeración que define los posibles estados de autenticación.
enum AuthStatus { checking, authenticated, notAuthenticated }

// Clase que representa el estado de autenticación.
class AuthState {
  final AuthStatus authStatus; // Estado actual de autenticación.
  final User? user; // Usuario autenticado (si existe).
  final String errorMessage; // Mensaje de error (si existe).

  // Constructor con valores predeterminados.
  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  // Método para crear una copia del estado con valores actualizados.
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}