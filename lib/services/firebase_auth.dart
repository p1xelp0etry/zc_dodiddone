import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Метод для регистрации нового пользователя
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      // Используем метод createUserWithEmailAndPassword для регистрации
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Отправляем запрос на подтверждение почты
      await userCredential.user!.sendEmailVerification();
      // Возвращаем объект UserCredential, содержащий информацию о новом пользователе
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок при регистрации
      if (e.code == 'weak-password') {
        // Пароль слишком слабый
        throw Exception('Пароль слишком слабый');
      } else if (e.code == 'email-already-in-use') {
        // Электронная почта уже используется
        throw Exception('Электронная почта уже используется');
      } else {
        // Другая ошибка
        throw Exception('Ошибка при регистрации: ${e.code}');
      }
    } catch (e) {
      // Обработка других ошибок
      throw Exception('Ошибка при регистрации: ${e.toString()}');
    }
  }

  // Метод для входа в систему
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Используем метод signInWithEmailAndPassword для входа
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Проверяем, подтверждена ли почта
      if (!userCredential.user!.emailVerified) {
        // Если почта не подтверждена, отправляем запрос на подтверждение
        await userCredential.user!.sendEmailVerification();
        throw Exception('Пожалуйста, подтвердите свою почту');
      }
      // Возвращаем объект UserCredential, содержащий информацию о пользователе
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок при входе
      if (e.code == 'user-not-found') {
        // Пользователь не найден
        throw Exception('Пользователь не найден');
      } else if (e.code == 'wrong-password') {
        // Неверный пароль
        throw Exception('Неверный пароль');
      } else {
        // Другая ошибка
        throw Exception('Ошибка при входе: ${e.code}');
      }
    } catch (e) {
      // Обработка других ошибок
      throw Exception('Ошибка при входе: ${e.toString()}');
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    try {
      // Используем метод signOut для выхода
      await _auth.signOut();
    } catch (e) {
      // Обработка ошибок при выходе
      throw Exception('Ошибка при выходе: ${e.toString()}');
    }
  }

  // Метод для получения текущего пользователя
  User? getCurrentUser() {
    // Возвращаем текущего пользователя, если он авторизован
    return _auth.currentUser;
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// class AuthenticationService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Метод для регистрации нового пользователя
//   Future<UserCredential> registerWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       // Используем метод createUserWithEmailAndPassword для регистрации
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       // Возвращаем объект UserCredential, содержащий информацию о новом пользователе
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       // Обработка ошибок при регистрации
//       if (e.code == 'weak-password') {
//         // Пароль слишком слабый
//         throw Exception('Пароль слишком слабый');
//       } else if (e.code == 'email-already-in-use') {
//         // Электронная почта уже используется
//         throw Exception('Электронная почта уже используется');
//       } else {
//         // Другая ошибка
//         throw Exception('Ошибка при регистрации: ${e.code}');
//       }
//     } catch (e) {
//       // Обработка других ошибок
//       throw Exception('Ошибка при регистрации: ${e.toString()}');
//     }
//   }

//   // Метод для входа в систему
//   Future<UserCredential> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       // Используем метод signInWithEmailAndPassword для входа
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       // Возвращаем объект UserCredential, содержащий информацию о пользователе
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       // Обработка ошибок при входе
//       if (e.code == 'user-not-found') {
//         // Пользователь не найден
//         throw Exception('Пользователь не найден');
//       } else if (e.code == 'wrong-password') {
//         // Неверный пароль
//         throw Exception('Неверный пароль');
//       } else {
//         // Другая ошибка
//         throw Exception('Ошибка при входе: ${e.code}');
//       }
//     } catch (e) {
//       // Обработка других ошибок
//       throw Exception('Ошибка при входе: ${e.toString()}');
//     }
//   }

//   // Метод для выхода из системы
//   Future<void> signOut() async {
//     try {
//       // Используем метод signOut для выхода
//       await _auth.signOut();
//     } catch (e) {
//       // Обработка ошибок при выходе
//       throw Exception('Ошибка при выходе: ${e.toString()}');
//     }
//   }

//   // Метод для получения текущего пользователя
//   User? getCurrentUser() {
//     // Возвращаем текущего пользователя, если он авторизован
//     return _auth.currentUser;
//   }
// }




