import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final credential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'wrong-password') {
          message = 'The old password is incorrect.';
        } else if (e.code == 'weak-password') {
          message = 'The new password provided is too weak.';
        } else {
          message = 'The old password is incorrect.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Change Password',
            style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        leadingWidth: 70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                _oldPasswordField(),
                const SizedBox(
                  height: 20,
                ),
                _newPasswordField(),
                const SizedBox(
                  height: 20,
                ),
                _confirmPasswordField(),
                const SizedBox(
                  height: 50,
                ),
                _changePasswordButton(context),
                if (_isLoading)
                  const SizedBox(
                    height: 50,
                  ),
                if (_isLoading)
                  const CircularProgressIndicator(), // Add the loading spinner here
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _oldPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Old Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _oldPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your old password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _newPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a new password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _confirmPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm New Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            } else if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _changePasswordButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA3D5D4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true; // Start loading
          });
          await _changePassword(
            _oldPasswordController.text,
            _newPasswordController.text,
          );
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      },
      child: const Text(
        "Change Password",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
