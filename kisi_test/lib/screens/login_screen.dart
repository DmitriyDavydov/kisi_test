import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kisi_test/screens/card_screen.dart';
import 'package:kisi_test/services/network_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    final networkService = NetworkService(
      dio: Dio(),
      baseUrl: 'https://aspen.bridgewaterlabs.com',
    );

    setState(() {
      _isLoading = true;
    });

    networkService
        .login(email: _emailController.text, password: _passwordController.text)
        .then((response) {
      setState(() {
        if (response.statusCode == 200) {
          print('Responce is ok');
          setState(() {
            _isLoading = false;
            _emailController.text = '';
            _passwordController.text = '';

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CardScreen()),
            );
          });
        }
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error: $error');
    });
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                        /*
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final response = networkService.login(
                            email: _emailController.text,
                            password: _emailController.text,
                          );
                          print('printing response');
                          print(response);
                          print(response);
                        },
                         */
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
