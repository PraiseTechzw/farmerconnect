import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _bucketName = 'farmer_connect_bucket';

  // Initialize Supabase
  static Future<void> initialize(String url, String anonKey) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  // Storage methods
  Future<String> uploadFile(String path, Uint8List bytes, String contentType) async {
    final response = await _client.storage
        .from(_bucketName)
        .uploadBinary(path, bytes, fileOptions: FileOptions(contentType: contentType));
    
    return _client.storage.from(_bucketName).getPublicUrl(path);
  }

  Future<void> deleteFile(String path) async {
    await _client.storage.from(_bucketName).remove([path]);
  }

  Future<List<FileObject>> listFiles(String path) async {
    return await _client.storage.from(_bucketName).list(path: path);
  }

  Future<String> getPublicUrl(String path) async {
    return _client.storage.from(_bucketName).getPublicUrl(path);
  }
} 