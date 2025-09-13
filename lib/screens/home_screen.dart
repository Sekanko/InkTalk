import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SignatureController controller = SignatureController(
    penColor: Colors.white,
    penStrokeWidth: 3,
    exportPenColor: Colors.red,
    exportBackgroundColor: Colors.black,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Signature(
            controller: controller,
            width: double.infinity,
            height: 200,
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
