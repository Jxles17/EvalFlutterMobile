import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscureText = true; // Variable pour gérer l'affichage du mot de passe

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // L'utilisateur a été créé avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Compte créé avec succès! Vous pouvez maintenant vous connecter.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Gérer les erreurs de création de compte ici
      print('Erreur de création de compte: $e');
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de création de compte: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                    obscureText: _obscureText,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Affiche un indicateur de chargement si l'inscription est en cours
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 50),
                shadowColor: Colors.pink,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
              ),
              child: Text(
                'S\'inscrire',
              ),
              onPressed: () async {
                await signUp(_emailController.text, _passwordController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
