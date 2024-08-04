import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../services/firebase_auth.dart'; // Импортируем AuthenticationService

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEmailVerified = false; // Флаг для проверки подтверждения почты
  String? userAvatarUrl; // URL аватара пользователя
  final AuthenticationService _authService = AuthenticationService(); // Создаем экземпляр AuthenticationService

  @override
  void initState() {
    super.initState();
    // Получаем информацию о пользователе
    _getUserData();
  }

  // Метод для получения информации о пользователе
  Future<void> _getUserData() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        isEmailVerified = user.emailVerified;
        userAvatarUrl = user.photoURL; // Получаем URL аватара
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          CircleAvatar(
            radius: 50,
            backgroundImage: userAvatarUrl != null
                ? NetworkImage(userAvatarUrl!) // Используем URL аватара
                : const AssetImage('assets/_1.png'), // Используем дефолтный аватар
          ),
          const SizedBox(height: 20),
          // Почта
          Text(
            _authService.getCurrentUser()?.email ?? '', // Получаем почту пользователя
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (!isEmailVerified)
            ElevatedButton(
              onPressed: () {
                // Обработка отправки запроса подтверждения почты
                // Например, можно показать диалог с сообщением о том, что письмо отправлено
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                            builder:(context) => const LoginPage())),// MaterialPageRoute
                       child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),
          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              // Выход из системы
              try {
                await _authService.signOut();
                // Переход на страницу входа
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } catch (e) {
                // Обработка ошибок
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}


