# JSON to Dart Pro 🛠️📱

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/d76080d5669c4568984ef53bd8dca09b)](https://app.codacy.com?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

An advanced, production-ready developer tool built with **Flutter** to instantly convert raw JSON objects into clean, type-safe **Dart model classes** for Flutter applications.

---

## 🌟 Key Features

- **Nested Object Support:** Automatically parses and generates decoupled classes for deeply nested JSON objects.
- **Robust List Handling:** Handles collections of primitives (`String`, `int`, `double`, `bool`) and arrays of custom objects.
- **Complete Serialization:** Generates idiomatic `fromJson` factory constructors and `toJson` serialization methods for every class.
- **Syntax Highlighting:** Integrated code visualization with real-time Dart syntax coloring.
- **Modern Material 3 UI:** Clean interface styled with Material Design 3 and Google Fonts typography.
- **CamelCase Sanitization:** Automatically converts snake_case JSON keys into standard Dart camelCase properties.
- **Clipboard Integration:** One-click copy for fast workflow integration.
- **Automated Verification:** Cross-platform continuous integration (CI) pipeline covering static analysis and unit testing..

---

## 📁 Project Architecture

```text
├── lib/
│   ├── main.dart             # Modern Material 3 UI, state management, and input forms
│   └── json_parser.dart      # Core tokenization, type inference, and Dart code generation logic
├── test/
│   └── widget_test.dart      # Automated regression and validation unit test suite
├── .github/workflows/        # Automated continuous integration (CI) pipeline
└── docker-compose.yml        # Isolated containerized test runner environment
## 📱 Project Classification
This project is an open-source **Client-Side Mobile & Desktop Developer Tool** built exclusively with Flutter and Dart. It contains zero cloud infrastructure or IaC components.
