import 'package:flutter/material.dart';
import 'package:voting_system/widget/fragmentHolder.dart';

const Color primaryBlue = Colors.blue;
const Color bgLight = Color(0xFFF5F5F5);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _voterIdCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _role = 'Admin';

  final _admins = {'admin1': 'admin123', 'admin2': 'admin456'};

  @override
  void dispose() {
    _voterIdCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, Color color) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));

  void _login() {
    final pass = _passwordCtrl.text.trim();
    if (_role == 'User') {
      _snack('User login coming soon', Colors.orange);
    } else {
      final user = _usernameCtrl.text.trim();
      if (user.isEmpty || pass.isEmpty)
        return _snack('Please fill all fields', Colors.orange);
      if (_admins[user] != pass)
        return _snack('Invalid Credentials', Colors.red);
      _snack('Admin Login Successful', Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FragmentPlaceholder()),
      );
    }
  }

  void _switchRole(String? role) {
    if (role == null) return;
    setState(() {
      _role = role;
      _voterIdCtrl.clear();
      _usernameCtrl.clear();
      _passwordCtrl.clear();
    });
  }

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    bool obscure = false,
  }) => TextField(
    controller: ctrl,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.how_to_vote_rounded,
                    size: 60,
                    color: primaryBlue,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Voting Login',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Secure access for voters and admins',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: 'User',
                        groupValue: _role,
                        activeColor: primaryBlue,
                        onChanged: _switchRole,
                      ),
                      const Text('User'),
                      const SizedBox(width: 16),
                      Radio<String>(
                        value: 'Admin',
                        groupValue: _role,
                        activeColor: primaryBlue,
                        onChanged: _switchRole,
                      ),
                      const Text('Admin'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_role == 'User') ...[
                    _field(_voterIdCtrl, 'Enter Voter ID'),
                    const SizedBox(height: 8),
                    const Text(
                      'User login coming soon',
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                  ],
                  if (_role == 'Admin')
                    _field(_usernameCtrl, 'Enter Admin Username'),
                  const SizedBox(height: 12),
                  _field(_passwordCtrl, 'Enter Password', obscure: true),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
