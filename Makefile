.PHONY: all test analyze format

all: format analyze test

test:
	flutter test --coverage

analyze:
	flutter analyze --fatal-infos --fatal-warnings

format:
	dart format --output=none --set-exit-if-changed .
