import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../data/models/course/material_model.dart';
import '../../finance/views/finance_view.dart';
import '../../project/views/project_view.dart';
import '../controllers/detail_modul_python_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PythonDetailModuleView extends GetView<PythonDetailModuleController> {
  const PythonDetailModuleView({super.key});

  final List<Widget> _pages = const [
    PythonDetailModuleContent(),
    ProjectView(),
    FinanceView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe8f6ff),

      body: Obx(() {
        return SafeArea(child: _pages[controller.selectedIndex.value]);
      }),

      bottomNavigationBar: _BottomNavBar(controller: controller),
    );
  }
}

class PythonDetailModuleContent extends GetView<PythonDetailModuleController> {
  const PythonDetailModuleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          // Tampilkan loading jika data sedang di-fetch
          if (controller.materials.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          // 1. Konten Utama
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EcoCampus",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // Menjauhkan teks ke kiri dan ikon ke kanan
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Kelas ${Get.arguments['courseTitle'] ?? 'Python'}",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(-1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(1.0, -1.0),
                            color: Colors.black,
                          ),
                          Shadow(offset: Offset(1.0, 1.0), color: Colors.black),
                          Shadow(
                            offset: Offset(-1.0, 1.0),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2D42),
                        // Warna background gelap agar ikon kuning terlihat kontras
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.python,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCourseStatus(),
                const SizedBox(height: 20),
                _buildModuleHeader(
                  controller.currentSection.value?.title ?? "Materi",
                ),
                Obx(
                  () => _buildSubChapterHeader(
                    controller.materials.isNotEmpty
                        ? controller.materials.first.title
                        : "Konten",
                  ),
                ),
                Obx(
                  () => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(color: Colors.white10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.materials.expand((material) {
                        // Kita ambil blocks dari SEMUA material dan gabungkan jadi satu list
                        return material.blocks.map(
                          (block) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _renderSingleBlock(block),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        // 2. Tombol Back Melayang
        Positioned(
          top: 30,
          left: -5,
          child: IconButton(
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_circle_left_outlined),
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseStatus() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Python Dasar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.moduletitle.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "0%",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildModuleHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF8ACEFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildSubChapterHeader(String title) {
    return Center(
      child: Container(
        width: 340,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF58B9FF), // Warna biru lebih gelap sedikit
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(
              27,
            ), // Hanya lengkungan di pojok kanan bawah
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.menu_book, size: 16, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSingleBlock(ContentBlock block) {
    switch (block.type) {
      case BlockType.text:
        return Text(
          block.content,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Colors.black,
          ),
        );

      case BlockType.image:
        return Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    block.content,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
              if (block.attributes['caption'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    block.attributes['caption'],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
            ],
          ),
        );

      case BlockType.video:
        final String? videoCaption = block.attributes['description'];
        return _buildVideoCard(block.content, videoCaption);
    }
  }

  Widget _buildVideoCard(String url, String? caption) {
    Widget videoWidget;

    // 1. LOGIKA YOUTUBE (Variabel: _ytController)
    if (url.contains('youtube.com') || url.contains('youtu.be')) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      final YoutubePlayerController ytController = YoutubePlayerController(
        initialVideoId: videoId ?? "",
        flags: const YoutubePlayerFlags(autoPlay: false),
      );

      videoWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: YoutubePlayer(controller: ytController),
        ),
      );
    }
    // 2. LOGIKA LOKAL (Memanggil widget di atas)
    else {
      videoWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: LocalVideoPlayer(url: url),
        ),
      );
    }

    // RETURN DENGAN STYLE CAPTION YANG SAMA DENGAN IMAGE
    return Center(
      child: Column(
        children: [
          videoWidget,
          if (caption != null && caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                caption,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class LocalVideoPlayer extends StatefulWidget {
  final String url;
  const LocalVideoPlayer({super.key, required this.url});

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  // PAKAI VARIABEL ASLI: _videoController
  late VideoPlayerController _videoController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = widget.url.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url))
        : VideoPlayerController.file(File(widget.url));
    _initializeVideoPlayerFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    // INI KUNCINYA: Mematikan suara saat pindah halaman
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return IconButton(
                          icon: Icon(
                            _videoController.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            setState(() {
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              VideoProgressIndicator(_videoController, allowScrubbing: true),
            ],
          );
        }
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final PythonDetailModuleController controller;

  const _BottomNavBar({required this.controller});

  static const Color _selectedBgColor = Color(0xffCDEEFF);
  static const Color _primaryColor = Color(0xe4000000);
  static const Color _unselectedColor = Colors.black;
  static const Color _barBgColor = Color(0xffe8f6ff);

  Widget _navTabItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: isSelected ? _primaryColor : _unselectedColor,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _primaryColor : _unselectedColor,
          ),
        ),
      ],
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: isSelected
                  ? BoxDecoration(
                      color: _selectedBgColor,
                      borderRadius: BorderRadius.circular(30),
                    )
                  : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: const BoxDecoration(
        color: _barBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, -0.5),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedIndex.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navTabItem(
              icon: Icons.home_outlined,
              label: "Home",
              index: 0,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(0),
            ),
            _navTabItem(
              icon: Icons.menu_book,
              label: "Project",
              index: 1,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(1),
            ),
            _navTabItem(
              icon: Icons.monetization_on_outlined,
              label: "Finance",
              index: 2,
              selectedIndex: selectedIndex,
              onTap: () => controller.changeTab(2),
            ),
          ],
        );
      }),
    );
  }
}
