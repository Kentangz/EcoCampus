import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analisis_data_penjualan_controller.dart';

class ProjectAnalisisDataView extends GetView<ProjectAnalisisDataController> {
  const ProjectAnalisisDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        // jika project belum ada, tampilkan judul default
        title: Obx(() => Text(ctrl.project.value?.title ?? 'Analisis Data Penjualan')),
        backgroundColor: const Color(0xFF2B7A78),
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.error.value != null) {
          return Center(child: Text('Error: ${ctrl.error.value}'));
        }

        final project = ctrl.project.value;
        if (project == null) {
          return Center(child: Text('Project tidak tersedia.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // banner image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: width > 600 ? 260 : 180,
                child: Image.asset(
                  project.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.image, size: 48)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // title & duration
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(project.duration, style: const TextStyle(fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // description
            Text(ctrl.description.value, style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),

            // quick metrics placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metricCard('Total Revenue', '—'),
                _metricCard('Total Transaksi', '—'),
                _metricCard('Avg Order', '—'),
              ],
            ),
            const SizedBox(height: 16),

            const Text('Langkah Pengerjaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // steps
            Column(
              children: ctrl.steps.map((s) => _stepCard(s)).toList(),
            ),

            const SizedBox(height: 20),

            // Buttons row — disable saat loading
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: ctrl.isLoading.value ? null : ctrl.downloadDataset,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Download Dataset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ctrl.isLoading.value ? null : () => ctrl.startWork(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Mulai Pengerjaan'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2B7A78)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: ctrl.isLoading.value ? null : ctrl.joinProject,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Gabung Proyek', style: TextStyle(color: Colors.black87)),
            ),

            const SizedBox(height: 30),
          ]),
        );
      }),
    );
  }

  Widget _metricCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _stepCard(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
