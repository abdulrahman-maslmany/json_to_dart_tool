import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import 'json_parser.dart';
import 'generators/clean_arch_generator.dart';
import 'utils/zip_downloader.dart';

void main() {
  runApp(const JsonToDartApp());
}

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON to Dart Pro & Clean Arch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum GeneratorMode { standard, freezed, mock }

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _classNameController =
      TextEditingController(text: 'MyModel');
  String _generatedDartCode = '';
  String? _errorMessage;
  GeneratorMode _selectedMode = GeneratorMode.standard;

  // دالة استخراج أسماء الحقول وأنواعها من الـ JSON
  Map<String, String> _extractFields(Map<String, dynamic> json) {
    final fields = <String, String>{};
    json.forEach((key, value) {
      if (value is int) {
        fields[key] = 'int';
      } else if (value is double) {
        fields[key] = 'double';
      } else if (value is bool) {
        fields[key] = 'bool';
      } else if (value is List) {
        fields[key] = 'List<dynamic>';
      } else if (value is Map) {
        fields[key] = 'Map<String, dynamic>';
      } else {
        fields[key] = 'String';
      }
    });
    return fields;
  }

  void _generateCode() {
    setState(() {
      _errorMessage = null;
    });

    final jsonInput = _jsonController.text.trim();
    final className = _classNameController.text.trim().isEmpty
        ? 'MyModel'
        : _classNameController.text.trim();

    if (jsonInput.isEmpty) {
      setState(() {
        _errorMessage = 'Please paste a valid JSON string first.';
        _generatedDartCode = '';
      });
      return;
    }

    try {
      final decoded = jsonDecode(jsonInput);
      if (decoded is! Map<String, dynamic>) {
        setState(() {
          _errorMessage =
              'Root JSON must be an object (e.g. {"key": "value"}), not a list or primitive value.';
          _generatedDartCode = '';
        });
        return;
      }

      String result;
      switch (_selectedMode) {
        case GeneratorMode.freezed:
          result = JsonParser.generateFreezedClass(className, decoded);
          break;
        case GeneratorMode.mock:
          result = JsonParser.generateMockData(className, decoded);
          break;
        case GeneratorMode.standard:
          result = JsonParser.generateDartClass(className, decoded);
          break;
      }

      setState(() {
        _generatedDartCode = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid JSON: $e';
        _generatedDartCode = '';
      });
    }
  }

  // دالة توليد وتنزيل حزمة الـ Clean Architecture كملف ZIP
  void _downloadCleanArchZip() {
    setState(() {
      _errorMessage = null;
    });

    final jsonInput = _jsonController.text.trim();
    final featureName = _classNameController.text.trim().isEmpty
        ? 'MyModel'
        : _classNameController.text.trim();

    if (jsonInput.isEmpty) {
      setState(() {
        _errorMessage = 'Please paste a valid JSON string before downloading ZIP.';
      });
      return;
    }

    try {
      final decoded = jsonDecode(jsonInput);
      if (decoded is! Map<String, dynamic>) {
        setState(() {
          _errorMessage = 'Root JSON must be an object to build Clean Architecture layers.';
        });
        return;
      }

      final fields = _extractFields(decoded);
      final modelCode = JsonParser.generateDartClass(featureName, decoded);

      final generator = CleanArchGenerator(
        featureName: featureName,
        fields: fields,
      );

      ZipDownloader.downloadCleanArchZip(
        featureName: featureName,
        generator: generator,
        modelCode: modelCode,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚡ Clean Architecture Feature "$featureName" downloaded as ZIP!'),
          backgroundColor: const Color(0xFF00B894),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error building Clean Architecture ZIP: $e';
      });
    }
  }

  void _copyToClipboard() {
    if (_generatedDartCode.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _generatedDartCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard! 📋'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openGumroad() {
    html.window.open('https://catherinefly.gumroad.com/l/cgxvaq', '_blank');
  }

  void _clearAll() {
    setState(() {
      _jsonController.clear();
      _classNameController.text = 'MyModel';
      _generatedDartCode = '';
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.code_rounded, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'JSON to Dart & Clean Arch Pro',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'FREE WEB',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6C5CE7),
        actions: [
          IconButton(
            tooltip: 'Clear All',
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pro Banner - Linked directly to Gumroad
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.amber, size: 28),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Want this directly inside VS Code? Get the Official Pro VS Code Extension!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6C5CE7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _openGumroad,
                        icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                        label: const Text(
                          'Get Pro (\$19)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Mode Selector Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      const Text(
                        'Target Format:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SegmentedButton<GeneratorMode>(
                        segments: const [
                          ButtonSegment(
                            value: GeneratorMode.standard,
                            label: Text('Standard Class'),
                            icon: Icon(Icons.data_object),
                          ),
                          ButtonSegment(
                            value: GeneratorMode.freezed,
                            label: Text('Freezed (Pro) 🔥'),
                            icon: Icon(Icons.bolt),
                          ),
                          ButtonSegment(
                            value: GeneratorMode.mock,
                            label: Text('Mock Data 🧪'),
                            icon: Icon(Icons.science_outlined),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _selectedMode = newSelection.first;
                          });
                          if (_jsonController.text.trim().isNotEmpty) {
                            _generateCode();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Root Class Name Input & Actions (With Clean Arch Button)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      child: TextField(
                        controller: _classNameController,
                        decoration: InputDecoration(
                          labelText: 'Feature / Class Name',
                          hintText: 'e.g. User, Product, Order',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _generateCode,
                      icon: const Icon(Icons.flash_on),
                      label: const Text(
                        'Generate Code',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // زر الـ Clean Architecture الجديد والمميز
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B894),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      onPressed: _downloadCleanArchZip,
                      icon: const Icon(Icons.folder_zip_rounded),
                      label: const Text(
                        'Download Clean Arch (ZIP) 📦',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Error Message if any
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),

                // Input Field
                TextField(
                  controller: _jsonController,
                  maxLines: 10,
                  style: const TextStyle(
                      fontFamily: 'monospace', fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Paste your JSON here ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Output Header with Copy Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedMode == GeneratorMode.freezed
                          ? 'Generated Freezed Dart Code:'
                          : _selectedMode == GeneratorMode.mock
                              ? 'Generated Mock Data (Static Instance):'
                              : 'Generated Dart Code:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _generatedDartCode.isNotEmpty
                            ? const Color(0xFF00B894)
                            : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _generatedDartCode.isNotEmpty ? _copyToClipboard : null,
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Code'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Output Display Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E272E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: SelectableText(
                    _generatedDartCode.isEmpty
                        ? '// Your Dart code or mock data will appear here ...'
                        : _generatedDartCode,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: _generatedDartCode.isEmpty
                          ? Colors.grey.shade500
                          : const Color(0xFFD2DAE2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}