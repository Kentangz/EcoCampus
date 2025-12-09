import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_ui_ux_controller.dart';

class ProjectUiUxView extends GetView<ProjectUiUxController> {
  const ProjectUiUxView({super.key});

  @override
  Widget build(BuildContext context) {
    final project = controller.project;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF71B4AD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(project.title, style: const TextStyle(color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: width > 600 ? 300 : 200,
              child: Image.asset(
                project.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 48)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(project.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF9BD8D3), borderRadius: BorderRadius.circular(8)),
              child: Text(project.duration, style: const TextStyle(fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 12),
          const Text('Deskripsi Proyek', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Proyek "Design UI/UX" bertujuan merancang antarmuka pengguna yang intuitif dan estetik untuk aplikasi EcoCampus. '
                'Lingkup: riset pengguna, wireframe, prototyping, dan usability testing.',
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Text('Deliverables', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            _Bullet(text: 'User research & persona'),
            _Bullet(text: 'Low & high-fidelity wireframes'),
            _Bullet(text: 'Interactive prototype (Figma)'),
            _Bullet(text: 'Style guide & component library'),
            _Bullet(text: 'Usability testing report'),
          ]),
          const SizedBox(height: 16),
          const Text('Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Minggu 1-2', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('Riset & pengumpulan kebutuhan', style: TextStyle(fontSize: 13)),
              ]),
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Minggu 3-6', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('Wireframe & prototyping', style: TextStyle(fontSize: 13)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          const Text('Tim yang dibutuhkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: const [
            _RoleChip(role: 'Product Owner'),
            _RoleChip(role: 'UX Researcher'),
            _RoleChip(role: 'UI Designer'),
            _RoleChip(role: 'Frontend Dev'),
            _RoleChip(role: 'Tester'),
          ]),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                ),
                child: const Text('Kembali'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.joinProject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF71B4AD),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Gabung Proyek', style: TextStyle(color: Colors.black87)),
              ),
            ),
          ]),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: 6),
        const Icon(Icons.check_circle_outline, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ]),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(role),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
