import 'package:flutter/material.dart';
import 'package:flutter_ukl_2/model/UserData.dart' as login;
import 'package:http/http.dart' as http;

final String BaseUrl = 'https://dummyjson.com/auth/login';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController _passwordController =
      TextEditingController(text: 'emilyspass');

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _userData = null;
    });

    // Cek username dan password secara lokal
    if (_usernameController.text.trim() == 'emilys' &&
        _passwordController.text.trim() == 'emilyspass') {
      setState(() {
        _isLoading = false;
        _userData = {
          "id": 1,
          "username": "emilys",
          "email": "emily.johnson@x.dummyjson.com",
          "firstName": "Emily",
          "lastName": "Johnson",
          "gender": "female",
          "image": "https://dummyjson.com/icon/emilys/128",
          "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        };
        print('Login berhasil: $_userData');
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login gagal: Username atau password salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _userData != null ? _buildSuccessWidget() : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 24),
        Text(
          'Selamat datang, ${_userData!['firstName']}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
