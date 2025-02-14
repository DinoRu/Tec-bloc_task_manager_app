import 'package:flutter/material.dart';

import '../widgets/instruction_content_page.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Инструкция"
        ),
      ),
      body: const InstructionPageContent(),
    );
  }
}