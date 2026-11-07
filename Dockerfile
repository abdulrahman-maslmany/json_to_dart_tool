# Use official verified Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS tester

WORKDIR /app

# Copy dependency definitions and pre-fetch
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy source code and test suite
COPY . .

# Run format verification, static analysis, and automated test suite with coverage
CMD ["sh", "-c", "dart format --output=none --set-exit-if-changed . && flutter analyze --fatal-infos --fatal-warnings && flutter test --coverage"]