import 'package:flutter/material.dart';

// View Kosong untuk Project
class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Halaman Project Sedang Dibangun",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
