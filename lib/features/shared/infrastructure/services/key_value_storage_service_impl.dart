import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

// Implementación del servicio de almacenamiento clave-valor utilizando SharedPreferences.
class KeyValueStorageServiceImpl extends KeyValueStorageService {

  // Método privado para obtener una instancia de SharedPreferences.
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Sobrescribe el método para obtener un valor almacenado según su clave.
  // El tipo genérico <T> permite manejar diferentes tipos de datos.
  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    // Se utiliza un switch para devolver el valor según el tipo genérico <T>.
    switch (T) {
      case int:
        return prefs.getInt(key) as T?; // Devuelve un entero si el tipo es int.
      case String:
        return prefs.getString(key) as T?; // Devuelve un string si el tipo es String.
      default:
        // Lanza un error si el tipo no está implementado.
        throw UnimplementedError('GET not implemented for type ${T.runtimeType}');
    }
  }

  // Sobrescribe el método para eliminar una clave específica del almacenamiento.
  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key); // Elimina la clave y devuelve true si tuvo éxito.
  }

  // Sobrescribe el método para establecer un valor en el almacenamiento.
  // El tipo genérico <T> permite manejar diferentes tipos de datos.
  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    // Se utiliza un switch para almacenar el valor según el tipo genérico <T>.
    switch (T) {
      case int:
        prefs.setInt(key, value as int); // Almacena un entero si el tipo es int.
        break;
      case String:
        prefs.setString(key, value as String); // Almacena un string si el tipo es String.
        break;
      default:
        // Lanza un error si el tipo no está implementado.
        throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}