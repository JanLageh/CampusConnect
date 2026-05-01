import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../appwrite_config.dart';

/// Service for handling Appwrite Storage operations
class AppwriteStorageService {
  final Storage _storage = AppwriteConfig.storage;

  /// Upload a file to Appwrite Storage
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - Unique ID for the file (use ID.unique() for auto-generation)
  /// [file] - The file to upload
  /// [permissions] - Optional permissions for the file
  Future<File> uploadFile({
    required String bucketId,
    required String fileId,
    required InputFile file,
    List<String>? permissions,
  }) async {
    try {
      final result = await _storage.createFile(
        bucketId: bucketId,
        fileId: fileId,
        file: file,
        permissions: permissions,
      );
      // ignore: avoid_print
      print('✅ File uploaded successfully: ${result.$id}');
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('❌ File upload failed: $e');
      rethrow;
    }
  }

  /// Get file preview URL
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - The ID of the file
  String getFilePreview({
    required String bucketId,
    required String fileId,
    int? width,
    int? height,
  }) {
    return '${AppwriteConfig.endpoint}/storage/buckets/$bucketId/files/$fileId/preview?project=${AppwriteConfig.projectId}${width != null ? '&width=$width' : ''}${height != null ? '&height=$height' : ''}';
  }

  /// Get file download URL
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - The ID of the file
  String getFileDownload({required String bucketId, required String fileId}) {
    return '${AppwriteConfig.endpoint}/storage/buckets/$bucketId/files/$fileId/download?project=${AppwriteConfig.projectId}';
  }

  /// Get file view URL
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - The ID of the file
  String getFileView({required String bucketId, required String fileId}) {
    return '${AppwriteConfig.endpoint}/storage/buckets/$bucketId/files/$fileId/view?project=${AppwriteConfig.projectId}';
  }

  /// Delete a file from Appwrite Storage
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - The ID of the file to delete
  Future<void> deleteFile({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      await _storage.deleteFile(bucketId: bucketId, fileId: fileId);
      // ignore: avoid_print
      print('✅ File deleted successfully: $fileId');
    } catch (e) {
      // ignore: avoid_print
      print('❌ File deletion failed: $e');
      rethrow;
    }
  }

  /// List files in a bucket
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [queries] - Optional queries for filtering
  Future<FileList> listFiles({
    required String bucketId,
    List<String>? queries,
  }) async {
    try {
      final result = await _storage.listFiles(
        bucketId: bucketId,
        queries: queries,
      );
      // ignore: avoid_print
      print('✅ Retrieved ${result.files.length} files');
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Failed to list files: $e');
      rethrow;
    }
  }

  /// Get file details
  ///
  /// [bucketId] - The ID of the storage bucket
  /// [fileId] - The ID of the file
  Future<File> getFile({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      final result = await _storage.getFile(bucketId: bucketId, fileId: fileId);
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Failed to get file: $e');
      rethrow;
    }
  }
}
