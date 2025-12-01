import 'package:ecocampus/app/shared/utils/tech_stack_icons.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TechStackPickerDialog extends StatefulWidget {
  final Function(String) onIconSelected;

  const TechStackPickerDialog({super.key, required this.onIconSelected});

  @override
  State<TechStackPickerDialog> createState() => _TechStackPickerDialogState();
}

class _TechStackPickerDialogState extends State<TechStackPickerDialog> {
  final TextEditingController _searchController = TextEditingController();

  List<MapEntry<String, IconData>> _filteredIcons = [];

  @override
  void initState() {
    super.initState();
    _filteredIcons = TechStackIcons.map.entries.toList();
    // Sort alphabetically
    _filteredIcons.sort((a, b) => a.key.compareTo(b.key));
  }

  void _filterIcons(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredIcons = TechStackIcons.map.entries.toList();
        _filteredIcons.sort((a, b) => a.key.compareTo(b.key));
      } else {
        _filteredIcons = TechStackIcons.map.entries
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
                  "Pilih Tech Stack",
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
              hintText: "Cari (misal: Flutter, React)...",
              onChanged: _filterIcons,
              onClear: () => _filterIcons(''),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: _filteredIcons.isEmpty
                  ? Center(
                      child: Text(
                        "Tech stack tidak ditemukan",
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
                            childAspectRatio: 0.8, // Adjusted for label
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
                                  color: TechStackIcons.getColor(entry.key),
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.key,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
