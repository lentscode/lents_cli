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

    final String useCasePath = _getPath("logic/use_cases", useCaseNameRaw);

    final File useCaseFile = File(useCasePath);

    if (useCaseFile.existsSync()) {
      throw StateError("Use case file already exists.");
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
