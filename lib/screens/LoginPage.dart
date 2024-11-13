import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identifiez-vous ou inscrivez-vous'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Se connecter avec"),
                Tab(text: "Créer un compte"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLoginForm(),
                  _buildSignUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'E-mail',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text('Connexion'),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: Text("J'ai oublié mon mot de passe", style: TextStyle(color: Colors.blue)),
        ),
        SizedBox(height: 16),
        Center(child: Text("Ou vous connecter à votre compte via")),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          icon: Icon(FontAwesomeIcons.google, color: Colors.grey),
          label: Text("Connectez-vous avec Google", style: TextStyle(color: Colors.grey)),
        ),
        Spacer(),
        Text(
          "En vous connectant, vous acceptez la Politique de confidentialité de Rentcars",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Nom complet',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'E-mail',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(Icons.visibility),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text('Créer un compte'),
        ),
        Spacer(),
        Text(
          "En vous inscrivant, vous acceptez la Politique de confidentialité de Rentcars",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
