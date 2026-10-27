
import 'package:flutter/material.dart';

class Firebase_test extends StatefulWidget {
  const Firebase_test({super.key});

  @override
    State<Firebase_test> createState() => _Firebase_test();
  }
  
  class _Firebase_test extends State<Firebase_test> {
    String message = "";
    
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        Map? pushArguments = arguments as Map?;
        setState(() {
          message = pushArguments?['message'] ?? '';
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Test'),
        ),
        body: Center(
          child: Container(
            child: Text('push message: $message'),
          ),
        ),
      );
    }
  }
  


