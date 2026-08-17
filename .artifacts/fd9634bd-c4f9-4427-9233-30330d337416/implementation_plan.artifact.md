# Ultimate Enterprise Flutter Template (Functional + Standardized)

This plan transforms the current project into a "Golden Template" by implementing Functional Error Handling, strict Naming Conventions, and a centralized `CLAUDE.md` control file. Once finished, this setup can be copied to any new project to provide instant AI expertise.

## User Review Required

> [!IMPORTANT]
> **New Dependency**: `fpdart` will be added for functional `Either<Failure, T>` patterns.
> **Breaking Change**: `AppException` will be replaced by a `Failure` hierarchy.
> **Folder Refactor**: Feature folders will move to lowercase/singular, and layer folders to plural (e.g., `features/cart/domain/entities/`).

## Proposed Changes

### 1. The Entry Point (`CLAUDE.md`)
Create a root `CLAUDE.md` file as the primary AI instruction set.
- **Common Commands**: Lists `flutter pub run build_runner build`, `flutter test`, `flutter analyze`, etc.
- **Architecture**: Defines Feature-first layers (presentation, application, domain, data).
- **Naming Conventions**: Mandatory `snake_case`, singular feature folders, plural layer folders.
- **Tech Stack**: Fixed versions for BLoC, GoRouter, fpdart.
- **Do/Don't**: Explicit rules like "Always use Either", "Never use setState for global state".

### 2. Functional Core (`lib/core/error/`)
- **failure.dart**: Create the sealed Failure hierarchy (Server, Auth, Validation, Unexpected).
- **pubspec.yaml**: Add `fpdart`.

### 3. Structural Refactor
- Rename all folders in `lib/features/` to follow the new naming law.
- Update all internal imports.

### 4. Smart Skills & Guards (`.claude/` & `.cursor/`)
- Update `flutter-repository-gen` to return `Either` and enforce the new folder structure.
- Update `flutter-bloc-gen` to handle `Either` results using `.fold()`.
- Update `.cursor/rules/` to automate naming and architecture checks.

### 5. Memory Bank Sync
- Update `README.md`, `architecture.md`, and `techContext.md` to reflect the "Functional Clean Architecture" status.

## Verification Plan

### Automated Tests
- `flutter pub get`
- `flutter analyze` (should be clean with new rules).
- Generate a test feature with `/flutter-bloc-gen` and verify the output matches all rules.

### Manual Verification
- Verify the AI chat correctly identifies the new `CLAUDE.md` rules and refuses to generate non-compliant code.
