import 'package:fityes/api_config.dart';
import 'package:fityes/sprint_1/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  VerifyOtpPage({required this.email});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
   
    final url = Uri.parse('${ApiConfig.baseUrl}users/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": widget.email, "otp": _otpController.text}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } else {
      final data = json.decode(response.body);
      setState(() {
        _error = data['message'] ?? 'Erreur de vérification';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('OTP Verification',
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Enter the code received by email',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: ' OTP Code',
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'code is required'),
                    MinLengthValidator(6,
                        errorText: 'The code must contain 6 digits'),
                  ]),
                ),
                const SizedBox(height: 15),

                if (_error != null)
                  Text(_error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14)),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9fbef7),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify OTP",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

