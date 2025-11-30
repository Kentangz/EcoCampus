import 'package:ecocampus/app/shared/utils/app_icons.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconPickerDialog extends StatefulWidget {
  final Function(String) onIconSelected;

  const IconPickerDialog({super.key, required this.onIconSelected});

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  List<MapEntry<String, IconData>> _filteredIcons = [];

  @override
  void initState() {
    super.initState();
    _filteredIcons = AppIcons.map.entries.toList();
  }

  void _filterIcons(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIcons = AppIcons.map.entries.toList();
      } else {
        _filteredIcons = AppIcons.map.entries
            .where(
              (entry) => entry.key.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 500,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pilih Ikon",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 15),

            CustomSearchBar(
              controller: _searchController,
              hintText: "Cari ikon (misal: school)...",
              onChanged: _filterIcons,
              onClear: () => _filterIcons(''),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: _filteredIcons.isEmpty
                  ? Center(
                      child: Text(
                        "Ikon tidak ditemukan",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : GridView.builder(
                      itemCount: _filteredIcons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        final entry = _filteredIcons[index];
                        return InkWell(
                          onTap: () {
                            widget.onIconSelected(entry.key);
                            Get.back();
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  entry.value,
                                  color: const Color(0xFF6C63FF),
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
