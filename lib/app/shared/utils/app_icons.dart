import 'package:flutter/material.dart';

class AppIcons {
  // Peta lengkap String -> IconData
  // Kamu bisa menambahkan ikon lain di sini sesuai kebutuhan
  static final Map<String, IconData> map = {
    // --- Umum ---
    'home': Icons.home,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'person': Icons.person,
    'settings': Icons.settings,
    'info': Icons.info,
    'help': Icons.help,
    'warning': Icons.warning,
    'search': Icons.search,
    'menu': Icons.menu,
    'close': Icons.close,
    'add': Icons.add,
    'delete': Icons.delete,
    'edit': Icons.edit,
    'share': Icons.share,
    'check': Icons.check,
    'notifications': Icons.notifications,

    // --- Akademik & Karir ---
    'school': Icons.school,
    'book': Icons.book,
    'library_books': Icons.library_books,
    'class': Icons.class_,
    'computer': Icons.computer,
    'code': Icons.code,
    'work': Icons.work,
    'business': Icons.business,
    'analytics': Icons.analytics,
    'science': Icons.science,
    'engineering': Icons.engineering,
    'psychology': Icons.psychology,
    'history_edu': Icons.history_edu,
    'language': Icons.language,
    'translate': Icons.translate,
    'calculate': Icons.calculate,

    // --- Seni & Kreativitas ---
    'brush': Icons.brush,
    'palette': Icons.palette,
    'music_note': Icons.music_note,
    'music_video': Icons.music_video,
    'movie': Icons.movie,
    'camera_alt': Icons.camera_alt,
    'videocam': Icons.videocam,
    'theater_comedy': Icons.theater_comedy,
    'draw': Icons.draw,
    'color_lens': Icons.color_lens,
    'photo': Icons.photo,
    'mic': Icons.mic,

    // --- Olahraga & Kesehatan ---
    'sports_soccer': Icons.sports_soccer,
    'sports_basketball': Icons.sports_basketball,
    'sports_tennis': Icons.sports_tennis,
    'sports_esports': Icons.sports_esports,
    'fitness_center': Icons.fitness_center,
    'directions_run': Icons.directions_run,
    'pool': Icons.pool,
    'spa': Icons.spa,
    'health_and_safety': Icons.health_and_safety,
    'local_hospital': Icons.local_hospital,

    // --- Event & Waktu ---
    'event': Icons.event,
    'schedule': Icons.schedule,
    'timer': Icons.timer,
    'alarm': Icons.alarm,
    'calendar_today': Icons.calendar_today,
    'date_range': Icons.date_range,
    'celebration': Icons.celebration,
    'cake': Icons.cake,

    // --- Teknologi & Gadget ---
    'smartphone': Icons.smartphone,
    'laptop': Icons.laptop,
    'keyboard': Icons.keyboard,
    'mouse': Icons.mouse,
    'memory': Icons.memory,
    'wifi': Icons.wifi,
    'bluetooth': Icons.bluetooth,
    'cloud': Icons.cloud,

    // --- Alam & Lingkungan ---
    'eco': Icons.eco,
    'nature': Icons.nature,
    'forest': Icons.forest,
    'water_drop': Icons.water_drop,
    'sunny': Icons.sunny,
    'local_florist': Icons.local_florist,
    'pets': Icons.pets,

    // --- Transportasi & Peta ---
    'map': Icons.map,
    'place': Icons.place,
    'flight': Icons.flight,
    'directions_bus': Icons.directions_bus,
    'directions_car': Icons.directions_car,
    'directions_bike': Icons.directions_bike,
  };

  // Helper untuk mendapatkan IconData dari String
  static IconData getIcon(String name) {
    return map[name] ?? Icons.help_outline; // Default icon
  }
}
