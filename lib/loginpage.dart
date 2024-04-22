import 'package:evalflutter/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscureText = true; // Variable pour gérer l'affichage du mot de passe

  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // L'authentification a réussi, naviguer vers la page suivante
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: '')),
      );
    } catch (e) {
      // Gérer les erreurs d'authentification ici
      print('Erreur de connexion: $e');
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur de connexion: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // L'utilisateur a été créé avec succès
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Compte créé avec succès!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      // Gérer les erreurs de création de compte ici
      print('Erreur de création de compte: $e');
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur de création de compte: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _resetPassword() async {
    // Afficher une boîte de dialogue pour que l'utilisateur entre son email
    String? email = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController _emailController = TextEditingController();
        return AlertDialog(
          title: Text('Réinitialiser le mot de passe'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Entrez votre email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_emailController.text);
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );

    // Vérifier si l'email est vide
    if (email != null && email.isNotEmpty) {
      try {
        // Envoyer un lien de réinitialisation du mot de passe
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Un lien de réinitialisation de mot de passe a été envoyé à votre adresse email.'),
          ),
        );
      } catch (e) {
        // Gérer les erreurs
        print('Erreur lors de l\'envoi du lien de réinitialisation : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi du lien de réinitialisation : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
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
                ? CircularProgressIndicator() // Affiche un indicateur de chargement si la connexion est en cours
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
                'Login',
              ),
              onPressed: () async {
                User? user = await signIn(_emailController.text, _passwordController.text);
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Vos cours'),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Rediriger l'utilisateur vers la page de réinitialisation de mot de passe
                _resetPassword();
              },
              child: Text('Mot de passe oublié ?'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Rediriger l'utilisateur vers la page d'inscription
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text('Pas encore inscrit ? S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
