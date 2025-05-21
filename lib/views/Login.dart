import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ukl_2/service/url.dart' as url;
import 'package:flutter_ukl_2/model/UserData.dart';
import 'package:flutter_ukl_2/views/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  bool _obscurePassword = true; // Tambahkan ini

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
        // Tampilkan di debug console
        print('Login berhasil!: $_userData');
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
       appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.music_note, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/playlist');
          },
        ),
        elevation: 4,
      ),
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
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword, // Ubah ini
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
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 24),
        Text(
          'Selamat datang, ${_userData!['firstName']}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Username: ${_userData!['username']}'),
        Text('Email: ${_userData!['email']}'),
        Text('Nama Lengkap: ${_userData!['firstName']} ${_userData!['lastName']}'),
        Text('Gender: ${_userData!['gender']}'),
        if (_userData!['image'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Image.network(_userData!['image'], height: 80),
          ),
        const SizedBox(height: 16),
        Text('Token: ${_userData!['accessToken']}'),
        Text('Refresh Token: ${_userData!['refreshToken']}'),
      ],
    );
  }
}