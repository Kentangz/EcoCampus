import 'package:ecocampus/app/shared/widgets/filter_chip.dart';
import 'package:ecocampus/app/shared/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecocampus/app/data/models/news/news_model.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/news_admin_controller.dart';

class NewsListAdminView extends GetView<NewsAdminController> {
  const NewsListAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchNews();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "Daftar Berita",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () => Get.toNamed('/admin-news-form'),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                CustomSearchBar(
                  controller: controller.searchController,
                  hintText: "Cari judul berita...",
                ),
                const SizedBox(height: 12),
                _buildFilterAndSortBar(),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.visibleNews;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        "Tidak ada berita ditemukan",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildNewsItem(list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===================== FILTER & SORT =====================
  Widget _buildFilterAndSortBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.sortOrder.value,
                  icon: const Icon(Icons.sort, size: 20),
                  items: const [
                    DropdownMenuItem(value: 'terbaru', child: Text("Terbaru")),
                    DropdownMenuItem(value: 'terlama', child: Text("Terlama")),
                    DropdownMenuItem(value: 'az', child: Text("A-Z")),
                    DropdownMenuItem(value: 'za', child: Text("Z-A")),
                  ],
                  onChanged: (val) {
                    if (val != null) controller.sortOrder.value = val;
                  },
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => Row(
              children: [
                CustomFilterChip(
                  label: 'Semua',
                  isSelected: controller.filterStatus.value == 'semua',
                  onTap: () => controller.filterStatus.value = 'semua',
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Published',
                  isSelected: controller.filterStatus.value == 'published',
                  onTap: () => controller.filterStatus.value = 'published',
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Draft',
                  isSelected: controller.filterStatus.value == 'draft',
                  onTap: () => controller.filterStatus.value = 'draft',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== ITEM BERITA =====================
  Widget _buildNewsItem(NewsModel news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),

              // Thumbnail
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: news.imageUrl.isEmpty
                    ? Container(
                        width: 55,
                        height: 55,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.white),
                      )
                    : Image.network(
                        news.imageUrl,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
              ),

              // Title
              title: Text(
                news.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),

              // Published status
              subtitle: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: news.isPublished ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    news.isPublished ? "Published" : "Draft",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),

              // Action Buttons
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // PUBLISH SWITCH
                  Switch(
                    value: news.isPublished,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      controller.togglePublishById(news.id, value);
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.toNamed('/news-admin-form', arguments: news);
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.deleteNews(news.id),
                  ),
                ],
              ),
            ),
          ),

          // Cloud Sync Tag
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: news.isSynced ? Colors.green : Colors.orange,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    news.isSynced ? Icons.cloud_done : Icons.cloud_upload,
                    size: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
