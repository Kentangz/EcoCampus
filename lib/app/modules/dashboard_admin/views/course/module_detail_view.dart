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
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 100,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  itemCount: controller.sections.length,
                  onReorder: controller.reorderSections,
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 5.0,
                      color: Colors.transparent,
                      shadowColor: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final section = controller.sections[index];
                    return Container(
                      key: ValueKey(section.id),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: _buildSectionItem(controller, section),
                    );
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

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: ExpansionTile(
            controller: controller.getTileController(section.id!),
            onExpansionChanged: (isOpen) {
              if (isOpen) controller.onSectionExpanded(section.id!);
            },
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blueGrey,
                    size: 20,
                  ),
                  onPressed: () =>
                      controller.showSectionDialog(existingSection: section),
                  tooltip: "Edit Judul",
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => controller.deleteSection(section.id!),
                  tooltip: "Hapus Section",
                ),
                const SizedBox(width: 8),
                const Icon(Icons.drag_handle, color: Colors.grey),
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
              else if (materials.length <= 1)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return _buildMaterialItem(
                      controller,
                      section,
                      material,
                      false,
                    );
                  },
                )
              else
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  onReorderStart: (_) => FocusScope.of(context).unfocus(),
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
                    return Container(
                      key: ValueKey(material.id),
                      child: _buildMaterialItem(
                        controller,
                        section,
                        material,
                        true,
                      ),
                    );
                  },
                ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton.icon(
                  onPressed: () => controller.addMaterialDirectly(
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

  Widget _buildMaterialItem(
    ModuleDetailController controller,
    SectionModel section,
    MaterialModel material,
    bool isReorderable,
  ) {
    return ListTile(
      leading: const Icon(Icons.description, color: Color(0xFF6C63FF)),
      title: Text(
        material.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          Text(
            "${material.blocks.length} Konten",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 8),
          Icon(
            material.isSynced ? Icons.cloud_done : Icons.cloud_upload,
            size: 16,
            color: material.isSynced ? Colors.green : Colors.orange,
          ),
        ],
      ),
      onTap: material.isSynced
          ? () => controller.navigateToBuilder(section.id!, material)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (material.isSynced) ...[
            IconButton(
              icon: const Icon(Icons.edit_note, size: 22, color: Colors.green),
              onPressed: () =>
                  controller.navigateToBuilder(section.id!, material),
              tooltip: "Edit Isi Konten",
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: Colors.red,
              ),
              onPressed: () =>
                  controller.deleteMaterial(section.id!, material.id!),
            ),
            if (isReorderable)
              const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ],
      ),
    );
  }
}
