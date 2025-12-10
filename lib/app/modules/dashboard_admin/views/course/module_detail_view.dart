import 'package:ecocampus/app/data/models/course/course_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/module_detail_controller.dart';
import 'package:flutter/material.dart' hide MaterialType;
import 'package:get/get.dart';

class ModuleDetailView extends GetView<ModuleDetailController> {
  const ModuleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Materi",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Text(
              controller.module.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          "Section Baru",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        return Container(
          color: Colors.white,
          child: controller.sections.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.layers_clear_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Belum ada section materi",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 100,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  itemCount: controller.sections.length,
                  itemBuilder: (context, index) {
                    final section = controller.sections[index];
                    return _buildSectionItem(controller, section);
                  },
                ),
        );
      }),
    );
  }

  Widget _buildSectionItem(
    ModuleDetailController controller,
    SectionModel section,
  ) {
    return StreamBuilder<List<MaterialModel>>(
      stream: controller.getMaterialsStream(section.id!),
      builder: (context, snapshot) {
        var materials = snapshot.data ?? [];
        materials.sort((a, b) => a.order.compareTo(b.order));

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: const Border(),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "#${section.order}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              section.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              onSelected: (val) {
                if (val == 'edit') {
                  controller.showSectionDialog(existingSection: section);
                }
                if (val == 'delete') {
                  controller.deleteSection(section.id!);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text("Edit Judul Section"),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    "Hapus Section",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            children: [
              const Divider(height: 1),
              if (materials.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Belum ada topik materi",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              else
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: materials.length,
                  onReorder: (oldIndex, newIndex) {
                    controller.reorderMaterials(
                      section.id!,
                      oldIndex,
                      newIndex,
                      materials,
                    );
                  },
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return ListTile(
                      key: ValueKey(material.id),
                      leading: const Icon(
                        Icons.description,
                        color: Colors.blue,
                      ),
                      title: Text(material.title),
                      subtitle: Text("${material.blocks.length} Konten"),
                      onTap: () => controller.navigateToBuilder(
                        section.id!,
                        material,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_note,
                              size: 22,
                              color: Colors.green,
                            ),
                            onPressed: () => controller.navigateToBuilder(
                              section.id!,
                              material,
                            ),
                            tooltip: "Edit Isi Konten",
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => controller.deleteMaterial(
                              section.id!,
                              material.id!,
                            ),
                          ),
                          const Icon(Icons.drag_handle, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton.icon(
                  onPressed: () => controller.showAddMaterialDialog(
                    section.id!,
                    materials.length + 1,
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Tambah Topik Materi"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6C63FF),
                    side: const BorderSide(color: Color(0xFF6C63FF)),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
