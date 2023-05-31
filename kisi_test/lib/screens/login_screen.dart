import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kisi_test/services/network_service.dart';

import 'card_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final networkService = NetworkService(
    dio: Dio(),
    baseUrl: 'https://aspen.bridgewaterlabs.com',
  );
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await networkService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final userKisiDetails = await networkService.getUserKisiDetails();

      setState(() {
        _isLoading = false;
        _emailController.text = '';
        _passwordController.text = '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardScreen(
              id: userKisiDetails.id,
              authToken: userKisiDetails.authToken,
              phoneKey: userKisiDetails.phoneKey,
              certificate: userKisiDetails.certificate,
            ),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error occurred');
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enter e-mail and password:',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40.0),
                    TextField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "E-mail",
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
