import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('${size.width} x ${size.height}');
    return Scaffold(
      body: Center(
        child: Text('${size.width} x ${size.height}'),
      ),
    );
  }
}
