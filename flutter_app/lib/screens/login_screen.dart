import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/session_service.dart';
import 'products_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';
  static const String _backgroundImage = 'assets/images/logobackground.jpg';
  static const String _logoImage = 'assets/images/logo.png';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  final _sessionService = SessionService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Appel API puis sauvegarde locale de la session utilisateur.
      final user = await _apiService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await _sessionService.saveUser(user);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'Connexion impossible. Verifiez vos identifiants et le serveur.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(LoginScreen._backgroundImage, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(120, 0, 0, 0)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
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
                              LoginScreen._logoImage,
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'SellCatalog',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      color: Colors.white,
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
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _loginInputDecoration(
                            context,
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return 'Veuillez saisir votre email.';
                            }
                            if (!email.contains('@')) {
                              return 'Veuillez saisir un email valide.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: _loginInputDecoration(
                            context,
                            labelText: 'Mot de passe',
                          ),
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre mot de passe.';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _LoginErrorMessage(message: _errorMessage!),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Se connecter'),
                        ),
                      ],
                    ),
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
      labelStyle: const TextStyle(color: Color.fromARGB(204, 0, 0, 0)),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(204, 0, 0, 0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }
}

class _LoginErrorMessage extends StatelessWidget {
  const _LoginErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
