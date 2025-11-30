import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecocampus/app/services/cloudinary_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QueueItem {
  String type;
  String docId;
  String fieldName;
  String path;
  int? arrayIndex;

  QueueItem({
    required this.type,
    required this.docId,
    required this.fieldName,
    required this.path,
    this.arrayIndex,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'docId': docId,
    'fieldName': fieldName,
    'path': path,
    'arrayIndex': arrayIndex,
  };

  factory QueueItem.fromJson(Map<String, dynamic> json) => QueueItem(
    type: json['type'] ?? 'upload',
    docId: json['docId'],
    fieldName: json['fieldName'] ?? '',
    path: json['path'] ?? json['localPath'],
    arrayIndex: json['arrayIndex'],
  );
}

class UploadQueueService extends GetxService {
  final _box = GetStorage();
  final CloudinaryService _cloudinary = CloudinaryService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _storageKey = 'pending_uploads';
  final RxList<QueueItem> _queue = <QueueItem>[].obs;

  bool _isProcessing = false;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _loadQueue();

    Connectivity().onConnectivityChanged.listen((result) {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () {
        if (!result.contains(ConnectivityResult.none)) {
          processQueue();
        }
      });
    });
  }

  void _loadQueue() {
    List<dynamic>? stored = _box.read(_storageKey);
    if (stored != null) {
      _queue.assignAll(stored.map((e) => QueueItem.fromJson(e)).toList());
      if (_queue.isNotEmpty) processQueue();
    }
  }

  void _saveQueue() {
    _box.write(_storageKey, _queue.map((e) => e.toJson()).toList());
  }

  void addToQueue(
    String docId,
    String fieldName,
    String localPath, {
    int? index,
  }) {
    if (localPath.startsWith('http') || localPath.isEmpty) return;

    bool isExists = _queue.any(
      (item) => item.type == 'upload' && item.path == localPath,
    );
    if (isExists) return;

    final item = QueueItem(
      type: 'upload',
      docId: docId,
      fieldName: fieldName,
      path: localPath,
      arrayIndex: index,
    );
    _queue.add(item);
    _saveQueue();

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () => processQueue());
  }

  void addDeleteToQueue(String urlToDelete) {
    if (!urlToDelete.startsWith('http')) return;

    bool isExists = _queue.any(
      (item) => item.type == 'delete' && item.path == urlToDelete,
    );
    if (isExists) return;

    final item = QueueItem(
      type: 'delete',
      docId: 'cleanup',
      fieldName: 'cleanup',
      path: urlToDelete,
    );
    _queue.add(item);
    _saveQueue();
  }

  Future<void> processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;

    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    _isProcessing = true;

    try {
      while (_queue.isNotEmpty) {
        var checkConn = await Connectivity().checkConnectivity();
        if (checkConn.contains(ConnectivityResult.none)) break;

        QueueItem item = _queue.first;

        if (item.type == 'delete') {
          bool success = await _cloudinary.deleteImage(item.path);

          if (success) {
            _queue.removeAt(0);
            _saveQueue();
          } else {
            break;
          }
        } else {
          File file = File(item.path);
          if (!file.existsSync()) {
            _queue.removeAt(0);
            _saveQueue();
            continue;
          }

          String? cloudUrl = await _cloudinary.uploadImage(file);

          if (cloudUrl != null) {
            await _updateFirestore(item, cloudUrl);
            _queue.removeAt(0);
            _saveQueue();
          } else {
            break;
          }
        }
      }
    } catch (e) {
      //
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _updateFirestore(QueueItem item, String cloudUrl) async {
    try {
      DocumentReference docRef = _db.collection('Activities').doc(item.docId);

      if (item.fieldName == 'heroImage') {
        await docRef.update({'heroImage': cloudUrl});
      } else if (item.fieldName == 'companyLogo') {
        await docRef.update({'companyLogo': cloudUrl});
      } else if (item.fieldName == 'gallery' && item.arrayIndex != null) {
        var snapshot = await docRef.get();
        if (snapshot.exists) {
          List<dynamic> currentList = List.from(snapshot.get('gallery') ?? []);

          if (currentList.length > item.arrayIndex!) {
            currentList[item.arrayIndex!] = cloudUrl;
            await docRef.update({'gallery': currentList});
          } else {
            await docRef.update({
              'gallery': FieldValue.arrayUnion([cloudUrl]),
            });
          }
        }
      } else if (item.fieldName == 'routines' && item.arrayIndex != null) {
        var snapshot = await docRef.get();
        if (snapshot.exists) {
          List<dynamic> rawList = List.from(snapshot.get('routines') ?? []);

          if (rawList.length > item.arrayIndex!) {
            Map<String, dynamic> updatedItem = Map.from(
              rawList[item.arrayIndex!],
            );
            updatedItem['imageUrl'] = cloudUrl;

            rawList[item.arrayIndex!] = updatedItem;
            await docRef.update({'routines': rawList});
          }
        }
      }
    } catch (e) {
      //
    }
  }
}
