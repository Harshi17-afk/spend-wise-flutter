import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final ok = await AuthService.validate(_usernameController.text, _passwordController.text);
    if (!mounted) return;
    if (ok) {
      await AuthService.setLoggedIn(true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String copyright = "\u00a9 Group10";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFFEE3EC9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo/hero
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
                  child: Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white.withOpacity(0.85),
                      child: const Text('SW', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('SpendWise', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                // Glass card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your username',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text('Login'))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(copyright, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
