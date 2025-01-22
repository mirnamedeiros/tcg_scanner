import 'package:flutter/material.dart';
import 'package:tcg_scanner/already_have_an_account.dart';
import 'package:tcg_scanner/constants.dart';
import 'package:tcg_scanner/home/home_screen.dart';
import 'package:tcg_scanner/screens/signup/signup_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcg_scanner/utils/token_manager.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // User Field
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Usuário",
              hintStyle: TextStyle(color: whiteColor),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Password Field
          TextFormField(
            controller: _passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Senha",
              hintStyle: TextStyle(color: whiteColor),
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          ElevatedButton(
            onPressed: () => _login(context),
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    // try {
      // // Combina o username e password no formato "username:password"
      // String credentials = '$username:$password';
      //
      // // Codifica a string "username:password" em Base64
      // String base64Credentials = base64.encode(utf8.encode(credentials));
      //
      // // Criando os cabeçalhos com o token de autorização básico
      // Map<String, String> headers = {
      //   'Authorization': 'Basic $base64Credentials',
      //   'Content-Type': 'application/json',
      // };
      //
      // final response = await http.post(
      //   Uri.parse('https://234b-2804-29b8-50d4-6c13-fc97-788f-d869-8842.ngrok-free.app/login'),
      //   headers: headers
      // );
      //
      // if (response.statusCode == 200) {
      //   final token = jsonDecode(response.body)['token'];
      //   await TokenManager().saveToken(token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
  //     } else {
  //       _showErrorDialog(context, 'Usuário ou senha inválidos.');
  //     }
  //   } catch (error) {
  //     _showErrorDialog(context, 'Erro ao conectar ao servidor.');
  //   }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

}