import 'package:flutter/material.dart';

import 'products_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';
  static const String _backgroundImage = 'assets/images/logobackground.jpg';
  static const String _logoImage = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _backgroundImage,
            fit: BoxFit.cover,
 
          ),
          const DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(60, 0, 0, 0)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _logoImage,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'SellCatalog',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w700,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 180),
                      Text(
                        'Connexion',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: _loginInputDecoration(
                          context,
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        obscureText: true,
                        decoration: _loginInputDecoration(
                          context,
                          labelText: 'Mot de passe',
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(ProductsScreen.routeName);
                        },
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _loginInputDecoration(
    BuildContext context, {
    required String labelText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: const Color.fromARGB(238, 255, 255, 255),
      labelStyle: TextStyle(color: const Color.fromARGB(204, 0, 0, 0)),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color.fromARGB(204, 0, 0, 0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }
}
