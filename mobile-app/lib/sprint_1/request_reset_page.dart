import 'package:fityes/api_config.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'verify_otp_page.dart';

class RequestResetPage extends StatefulWidget {
  @override
  _RequestResetPageState createState() => _RequestResetPageState();
}

class _RequestResetPageState extends State<RequestResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });


    final url = Uri.parse('${ApiConfig.baseUrl}users/auth/request-reset');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": _emailController.text}),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpPage(email: _emailController.text),
        ),
      );
    } else {
      final data = json.decode(response.body);
      setState(() {
        _error = data['message'] ?? 'Une erreur est survenue.';
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
                const Text('Forgot your password ?',
                    style: TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(height: 8),
                const Text('Receive your OTP code',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

               
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email obligatoire'),
                    EmailValidator(errorText: 'Email invalide'),
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
                    onPressed: _isLoading ? null : sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9fbef7),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Send OTP",
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
