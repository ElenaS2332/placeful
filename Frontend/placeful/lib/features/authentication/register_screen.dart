import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/logger_service.dart';
import 'package:placeful/common/services/service_locatior.dart';
import 'package:placeful/common/services/user_service.dart';
import 'package:placeful/features/authentication/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  final _userSvc = getIt<UserService>();
  final _authSvc = getIt<AuthService>();
  final _logger = getIt<LoggerService>();

  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;

  void _togglePass() => setState(() => _obscurePass = !_obscurePass);
  void _toggleConfirm() =>
      setState(() => _obscureConfirmPass = !_obscureConfirmPass);

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now.subtract(const Duration(days: 365 * 12)),
    );
    if (picked != null) {
      _dobCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _validEmail(String em) {
    final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return re.hasMatch(em);
  }

  bool _validAge(String raw) {
    try {
      final parts = raw.split('/');
      final dt = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      final age = DateTime.now().difference(dt).inDays ~/ 365;
      return age >= 12;
    } catch (_) {
      return false;
    }
  }

  Future<void> _register() async {
    final name = _fullNameCtrl.text.trim();
    final dob = _dobCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;

    String? error;
    if (name.length < 6) {
      error = 'Name must be at least 6 chars.';
    } else if (!_validAge(dob)) {
      error = 'You must be 12+ years old.';
    } else if (!_validEmail(email)) {
      error = 'Enter a valid email.';
    } else if (pass.length < 8) {
      error = 'Password needs 8+ chars.';
    } else if (pass != confirm) {
      error = 'Passwords do not match.';
    }

    if (error != null) {
      _showMsg(error);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userCredentials = await _authSvc.registerWithEmail(email, pass);
      await _userSvc.registerUser(
        firebaseUid: userCredentials.user?.uid ?? '',
        fullName: name,
        email: email,
        birthDate: DateTime.parse(
          "${dob.split('/')[2]}-${dob.split('/')[1].padLeft(2, '0')}-${dob.split('/')[0].padLeft(2, '0')}",
        ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      final msg =
          e.code == 'email-already-in-use'
              ? 'Email already in use.'
              : e.code == 'weak-password'
              ? 'Password too weak.'
              : 'Registration failed.';
      _showMsg(msg);
      _logger.logError(e.toString());
    } catch (e) {
      _showMsg('Unexpected error.');
      _logger.logError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDeco(String hint, {Widget? prefix, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6CA0FF), Color(0xFF1F45FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Text(
                    'CREATE ACCOUNT',
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: Colors.white24,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextField(
                            controller: _fullNameCtrl,
                            decoration: _inputDeco(
                              'Full Name',
                              prefix: const Icon(
                                Icons.person,
                                color: Colors.white70,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _dobCtrl,
                            readOnly: true,
                            onTap: _pickDob,
                            decoration: _inputDeco(
                              'Birthday',
                              prefix: const Icon(
                                Icons.calendar_today,
                                color: Colors.white70,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDeco(
                              'Email',
                              prefix: const Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscurePass,
                            decoration: _inputDeco(
                              'Password',
                              prefix: const Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: _togglePass,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPassCtrl,
                            obscureText: _obscureConfirmPass,
                            decoration: _inputDeco(
                              'Confirm Password',
                              prefix: const Icon(
                                Icons.lock_outline,
                                color: Colors.white70,
                              ),
                              suffix: IconButton(
                                icon: Icon(
                                  _obscureConfirmPass
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: _toggleConfirm,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF1F45FF),
                                              ),
                                        ),
                                      )
                                      : Text(
                                        'REGISTER',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Color(0xFF1F45FF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        ),
                    child: Text(
                      'Already have an account? Log in',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
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

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }
}
