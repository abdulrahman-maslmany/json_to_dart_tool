.PHONY: all test analyze format coverage

all: analyze test

format:
	dart format --set-exit-if-changed .

analyze:
	flutter analyze --fatal-infos --fatal-warnings

test:
	flutter test --coverage

coverage: test
	genhtml coverage/lcov.info -o coverage/html
