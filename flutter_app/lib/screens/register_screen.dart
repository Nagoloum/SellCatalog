import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/session_service.dart';
import 'products_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';
  static const String _backgroundImage = 'assets/images/backgoundimg.jpg';
  static const String _logoImage = 'assets/images/logo.png';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _apiService = ApiService();
  final _sessionService = SessionService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      // Creation du compte via l'API puis ouverture directe de la session.
      final user = await _apiService.register(
        prenom: _prenomController.text.trim(),
        nom: _nomController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await _sessionService.saveUser(user);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
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
          Image.asset(RegisterScreen._backgroundImage, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(56, 0, 0, 0)),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              RegisterScreen._logoImage,
                              width: 46,
                              height: 46,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'SellCatalog',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 56),
                        Text(
                          'Inscription',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _prenomController,
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            labelText: 'Prenom',
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nomController,
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            labelText: 'Nom',
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
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
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            context,
                            labelText: 'Mot de passe',
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return 'Minimum 4 caracteres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmPasswordController,
                          enabled: !_isLoading,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: _inputDecoration(
                            context,
                            labelText: 'Confirmer le mot de passe',
                          ),
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Les mots de passe ne correspondent pas.';
                            }
                            return null;
                          },
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          _RegisterErrorMessage(message: _errorMessage!),
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
                              : const Text('Creer mon compte'),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Retour a la connexion'),
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

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Champ obligatoire.';
    }
    return null;
  }

  InputDecoration _inputDecoration(
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }
}

class _RegisterErrorMessage extends StatelessWidget {
  const _RegisterErrorMessage({required this.message});

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
