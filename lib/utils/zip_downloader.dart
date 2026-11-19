import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:universal_html/html.dart' as html;
import '../generators/clean_arch_generator.dart';

class ZipDownloader {
  static void downloadCleanArchZip({
    required String featureName,
    required CleanArchGenerator generator,
    required String modelCode,
  }) {
    final archive = Archive();
    final feature = featureName.toLowerCase();

    void addFile(String path, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(path, bytes.length, bytes));
    }

    // 1. Domain Layer
    addFile('$feature/domain/entities/${feature}_entity.dart', generator.generateEntity());
    addFile('$feature/domain/repositories/${feature}_repository.dart', generator.generateRepositoryContract());
    addFile('$feature/domain/usecases/get_${feature}_usecase.dart', generator.generateUseCase());

    // 2. Data Layer
    addFile('$feature/data/models/${feature}_model.dart', modelCode);
    addFile('$feature/data/datasources/${feature}_remote_datasource.dart', generator.generateDataSource());
    addFile('$feature/data/repositories/${feature}_repository_impl.dart', generator.generateRepositoryImpl());

    // 3. Presentation Layer (Cubit)
    addFile('$feature/presentation/cubit/${feature}_cubit.dart', generator.generateCubit());

    // ضغط الملفات
    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) return;

    // تنزيل الملف في المتصفح
    final blob = html.Blob([zipData], 'application/zip');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '${feature}_clean_architecture.zip')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}