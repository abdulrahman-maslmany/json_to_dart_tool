FROM ghcr.io/cirruslabs/flutter:3.24.0

WORKDIR /app

# Copy dependency specifications
COPY pubspec*.yaml ./
RUN flutter pub get

# Copy source code and test suites
COPY . .

# Run static analysis and automated tests
CMD ["sh", "-c", "flutter analyze && flutter test --coverage"]
