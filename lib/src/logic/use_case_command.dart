part of "command.dart";

/// Command to create a use case.
class UseCaseCommand extends Command<String> {
  @override
  FutureOr<String>? run() => _createUseCase();

  @override
  String get description => "Creates a use case.";

  @override
  String get name => "use_case";

  String _createUseCase() {
    final String useCaseNameRaw = argResults!.rest[0];

    final String libraryPath = _getLibPath("logic");
    final String useCasePath = _getPath("logic/use_cases", useCaseNameRaw);

    final File libraryFile = File(libraryPath);
    final File useCaseFile = File(useCasePath);

    if (useCaseFile.existsSync()) {
      throw StateError("Use case file already exists.");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>[
          "library;",
          "",
          "export \"use_cases/$useCaseNameRaw/$useCaseNameRaw.dart\";",
        ].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          "export \"use_cases/$useCaseNameRaw/$useCaseNameRaw.dart\";",
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    useCaseFile.createSync(recursive: true);

    final String useCaseName = _snakeToPascalCase(useCaseNameRaw);

    useCaseFile.writeAsStringSync(
      <String>[
        "class ${useCaseName}UseCase {",
        "  Future<void> execute() async {}",
        "}",
        "",
      ].join("\n"),
    );

    return "Use case file created at $useCasePath";
  }
}
