import 'package:fityes/sprint_1/account.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.white, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 150), 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                        children: [
                          TextSpan(
                            text: 'Fit',
                            style: TextStyle(color: Colors.black), 
                          ),
                          TextSpan(
                            text: 'yes',
                            style: TextStyle(
                              color: Color.fromARGB(
                                  255, 139, 144, 244), 
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Everybody Can Train !',
                      style: TextStyle(
                        fontSize: 20,

                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/home.png', 
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
             
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 139, 144, 244),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
