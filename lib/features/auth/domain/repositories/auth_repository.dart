import '../entities/user.dart';

abstract class AuthRepository {
  // Se crean el meétodo checkAuthStatus para 
  Future<User> login( String email, String password );
  Future<User> register( String email, String password, String fullName );
  Future<User> checkAuthStatus( String token );

}