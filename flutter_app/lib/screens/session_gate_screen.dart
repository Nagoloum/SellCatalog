import 'package:flutter/material.dart';

import '../services/session_service.dart';
import 'login_screen.dart';
import 'products_screen.dart';

class SessionGateScreen extends StatefulWidget {
  const SessionGateScreen({super.key});

  static const String routeName = '/';

  @override
  State<SessionGateScreen> createState() => _SessionGateScreenState();
}

class _SessionGateScreenState extends State<SessionGateScreen> {
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _redirectFromSession();
  }

  Future<void> _redirectFromSession() async {
    final user = await _sessionService.getUser();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      user == null ? LoginScreen.routeName : ProductsScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
