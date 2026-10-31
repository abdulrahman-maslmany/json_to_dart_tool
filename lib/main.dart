import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:google_fonts/google_fonts.dart';
import 'json_parser.dart';

void main() {
  runApp(const JsonToDartApp());
}

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON to Dart Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const JsonToolScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class JsonToolScreen extends StatefulWidget {
  const JsonToolScreen({super.key});

  @override
  State<JsonToolScreen> createState() => _JsonToolScreenState();
}

class _JsonToolScreenState extends State<JsonToolScreen> {
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController(
    text: "MyModel",
  );
  String _generatedCode = "";

  void _generate() {
    if (_jsonController.text.trim().isEmpty) {
      _showSnackBar("Please paste some JSON first!");
      return;
    }

    try {
      final dynamic decoded = jsonDecode(_jsonController.text);
      String className = _classNameController.text.trim();
      if (className.isEmpty) className = "MyModel";

      setState(() {
        if (decoded is Map<String, dynamic>) {
          _generatedCode = JsonParser.generateDartClass(className, decoded);
        } else if (decoded is List && decoded.isNotEmpty) {
          if (decoded[0] is Map<String, dynamic>) {
            _generatedCode = JsonParser.generateDartClass(
              className,
              decoded[0] as Map<String, dynamic>,
            );
          } else {
            _generatedCode =
                "// The list contains primitive values, not objects.";
          }
        } else {
          _generatedCode =
              "// Please provide a valid JSON object or a non-empty list of objects.";
        }
      });
    } catch (e) {
      setState(() => _generatedCode = "// Error: Invalid JSON format!\n// $e");
    }
  }

  void _clear() {
    setState(() {
      _jsonController.clear();
      _generatedCode = "";
    });
  }

  void _copyToClipboard() {
    if (_generatedCode.isNotEmpty && !_generatedCode.startsWith("//")) {
      Clipboard.setData(ClipboardData(text: _generatedCode));
      _showSnackBar('Code copied to clipboard!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            const SizedBox(width: 10),
            Text(
              "JSON to Dart Pro",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline),
            tooltip: "Clear All",
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _classNameController,
                      decoration: const InputDecoration(
                        labelText: "Root Class Name",
                        prefixIcon: Icon(Icons.class_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.bolt),
                    label: const Text("Generate"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 24,
                      ),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jsonController,
                maxLines: 8,
                style: GoogleFonts.firaCode(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: "Paste your JSON here...",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.code, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Generated Dart Code:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height:
                    400, // Fixed height for mobile to prevent infinite height in scroll view
                decoration: BoxDecoration(
                  color: const Color(0xFF282A36), // Dracula background
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: HighlightView(
                          _generatedCode.isEmpty
                              ? "// Your Dart classes will appear here..."
                              : _generatedCode,
                          language: 'dart',
                          theme: draculaTheme,
                          textStyle: GoogleFonts.firaCode(fontSize: 13),
                        ),
                      ),
                    ),
                    if (_generatedCode.isNotEmpty &&
                        !_generatedCode.startsWith("//"))
                      Positioned(
                        top: 8,
                        right: 8,
                        child: FloatingActionButton.small(
                          onPressed: _copyToClipboard,
                          child: const Icon(Icons.copy_all),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
