import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'theme.dart';
import 'auth_service.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _initialDecision() async {
    final hasCreds = await AuthService.hasCredentials();
    if (!hasCreds) return false; // go to onboarding to create creds
    final loggedIn = await AuthService.isLoggedIn();
    return loggedIn; // true -> MainScreen, false -> Onboarding to allow login
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initialDecision(),
      builder: (context, snapshot) {
        final theme = buildAppTheme();
        if (!snapshot.hasData) {
          return MaterialApp(title: 'SpendWise', theme: theme, home: const SizedBox());
        }
        final goToMain = snapshot.data ?? false;
        return MaterialApp(
          title: 'SpendWise',
          theme: theme,
          home: goToMain ? const MainScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final username = TextEditingController();
    final password = TextEditingController();
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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Welcome to SpendWise', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('Create your credentials to sign in securely.' , textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextField(controller: username, decoration: const InputDecoration(labelText: 'Create Username', hintText: 'Enter a username')),
                    const SizedBox(height: 12),
                    TextField(controller: password, decoration: const InputDecoration(labelText: 'Create Password', hintText: 'Enter a password'), obscureText: true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (username.text.isEmpty || password.text.isEmpty) return;
                        await AuthService.saveCredentials(username.text, password.text);
                        await AuthService.setLoggedIn(true);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
                      },
                      child: const Text('Save and Continue'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      child: const Text('I already have an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
