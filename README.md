<div align="center">

# 🛠️ JSON to Dart Pro
### Instant, Type-Safe Dart Model & Serialization Generator for Flutter

[![DeepSource Active Issues](https://app.deepsource.com/gh/abdulrahman-maslmany/json_to_dart_tool.svg/?label=active+issues&show_trend=true&token=8fFFY2l0AOXcEDKido3-WdjP)](https://app.deepsource.com/gh/abdulrahman-maslmany/json_to_dart_tool/)
[![DeepSource Coverage](https://app.deepsource.com/gh/abdulrahman-maslmany/json_to_dart_tool.svg/?label=code+coverage&show_trend=true&token=8fFFY2l0AOXcEDKido3-WdjP)](https://app.deepsource.com/gh/abdulrahman-maslmany/json_to_dart_tool/)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/d76080d5669c4568984ef53bd8dca09b)](https://app.codacy.com?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![Flutter](https://img.shields.io/badge/Flutter-3.19%2B-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.3%2B-0175C2?logo=dart)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

<p align="center">
  A developer productivity utility designed to eliminate boilerplate code by converting complex, nested JSON payloads into decoupled, null-safe Dart data models with complete serialization logic.
</p>

</div>

---

## ⚡ Engineering & Architecture Highlights

* **Deterministic Type Inference:** Smart parsing engine that dynamically detects and infers Dart primitive types (`String`, `int`, `double`, `bool`) and distinguishes between homogeneous lists and arrays of nested objects.
* **Recursive AST-like Parser:** Decoupled class generation engine that recursively unwraps nested JSON trees into clean, standalone Dart classes without circular dependencies.
* **Idiomatic Dart Standards:** Enforces Dart style conventions by transforming `snake_case` API keys into proper `camelCase` fields while preserving raw mapping in `fromJson` / `toJson`.
* **Zero-Cloud & Privacy First:** 100% client-side compilation and parsing. Sensitive payloads and API structures never leave the local client environment.
* **Continuous Quality Assurance:** Integrated with **DeepSource** and **Codacy** to maintain zero anti-patterns, clean code standards, and security compliance on every commit.

---

## 🌟 Key Features

* **Recursive Nested Classes:** Automatically extracts sub-objects into standalone, reusable Dart classes.
* **Deep List Handling:** Seamlessly generates serialization for both primitive arrays (`List<int>`) and custom object collections (`List<UserModel>`).
* **Complete Serialization:** Produces boilerplate-free `factory fromJson(Map<String, dynamic> json)` and `Map<String, dynamic> toJson()` methods.
* **Material 3 Interface:** Styled using Google Fonts typography, responsive layout, and real-time syntax highlighting for generated code.
* **One-Click Workflow:** Instant clipboard integration for direct pasting into your Flutter models directory.

---

## 💻 Code Generation Preview

### Input (Raw JSON):
```json
{
  "user_id": 101,
  "profile": {
    "full_name": "Abdulrahman Maslmany",
    "is_active": true
  },
  "tags": ["mobile", "flutter", "unity"]
}
Output (Generated Dart Model):
Dart
class UserModel {
  final int userId;
  final Profile profile;
  final List<String> tags;

  UserModel({
    required this.userId,
    required this.profile,
    required this.tags,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['user_id'] ?? 0,
    profile: Profile.fromJson(json['profile'] ?? {}),
    tags: List<String>.from(json['tags'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'profile': profile.toJson(),
    'tags': tags,
  };
}
📁 Repository Structure
Text
├── lib/
│   ├── main.dart             # Material 3 UI shell, responsive state, and user actions
│   ├── json_parser.dart      # Pure Dart parsing logic, type inference & AST generator
│   └── controllers/          # Business logic and state coordination
├── test/
│   ├── widget_test.dart      # Automated regression and parser validation tests
│   └── json_tool_controller_test.dart # Controller unit tests
├── .github/workflows/        # Automated CI pipeline (Flutter analyze, lint & unit tests)
├── docker-compose.yml        # Containerized isolated testing environment
└── pubspec.yaml              # Package manifest and dependency lockfile
🚀 Getting Started & Local Verification
Prerequisites
Flutter SDK: >= 3.19.0
Dart SDK: >= 3.3.0
Run the App
Bash
git clone https://github.com/abdulrahman-maslmany/json_to_dart_tool.git
cd json_to_dart_tool
flutter pub get
flutter run
Run Tests & Code Analysis
Bash
flutter analyze
flutter test
📄 License
This project is open-source and available under the MIT License.
Code
---

### ما تم إصلاحه:
1. إغلاق علامات الـ ` ``` ` لكل كتلة كود (Code Block) لتختفي الخطوط والكلمات الحمراء.
2. تفعيل تلوين صيغة الكود البرمجي الخاص بـ `json` و `dart` و `bash`.
3. تنسيق العناوين والقوائم لتظهر بخطوط Markdown جميلة ونظيفة في واجهة GitHub.
