import 'package:ecocampus/app/data/models/course/course_model.dart';

import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/module_detail_controller.dart';
import 'package:flutter/material.dart' hide MaterialType;
import 'package:get/get.dart';

class ModuleDetailView extends StatelessWidget {
  const ModuleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ModuleDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kelola Modul",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              controller.module.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showSectionDialog(),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.playlist_add, color: Colors.white),
        label: const Text(
          "Tambah Section",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.sections.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.layers_clear_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 10),
                const Text("Belum ada section/sub-bab"),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80, top: 10),
          itemCount: controller.sections.length,
          itemBuilder: (context, index) {
            final section = controller.sections[index];
            return _buildSectionItem(controller, section);
          },
        );
      }),
    );
  }

  Widget _buildSectionItem(
    ModuleDetailController controller,
    SectionModel section,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: Text(
            "${section.order}",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: const Text("Tap untuk lihat materi"),
        trailing: PopupMenuButton(
          onSelected: (val) {
            if (val == 'edit') {
              controller.showSectionDialog(existingSection: section);
            }
            if (val == 'delete') controller.deleteSection(section.id!);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text("Edit Section")),
            const PopupMenuItem(
              value: 'delete',
              child: Text("Hapus Section", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        children: [
          StreamBuilder<List<MaterialModel>>(
            stream: controller.getMaterialsStream(section.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final materials = snapshot.data ?? [];
              final nextOrderNumber = materials.length + 1;

              return Column(
                children: [
                  const Divider(height: 1),
                  if (materials.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Belum ada materi",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: materials.length,
                      itemBuilder: (context, i) {
                        final material = materials[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            material.type == MaterialType.video
                                ? Icons.play_circle_fill
                                : Icons.article,
                            color: material.type == MaterialType.video
                                ? Colors.red
                                : Colors.green,
                          ),
                          title: Text(material.title),
                          subtitle: Text("Order: ${material.order}"),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () => controller.deleteMaterial(
                              section.id!,
                              material.id!,
                            ),
                          ),
                          onTap: () => controller.showMaterialDialog(
                            section.id!,
                            existingMaterial: material,
                          ),
                        );
                      },
                    ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton.icon(
                      onPressed: () => controller.showMaterialDialog(
                        section.id!,
                        nextOrder: nextOrderNumber,
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Tambah Materi"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
