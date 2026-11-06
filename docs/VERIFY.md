# 🧪 Automated Reproduction & Verification Guide

This document certifies that `json_to_dart_tool` is fully reproducible and verifiable from a clean environment without pre-cached dependencies.

## 🛠️ Verification Commands

```bash
# 1. Fetch locked dependencies
flutter pub get

# 2. Enforce official Dart formatting standards
dart format --output=none --set-exit-if-changed .

# 3. Strict static analysis (Zero warnings, zero infos)
flutter analyze --fatal-infos --fatal-warnings

# 4. Run full test suite with coverage enforcement (>= 70%)
flutter test --coverage
