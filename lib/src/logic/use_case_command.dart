part of "command.dart";

/// Command to create a use case.
class UseCaseCommand extends Command<String> {
  UseCaseCommand() {
    argParser.addFlag(
      "part",
      abbr: "p",
      help: "Create a part file instead of a separate file.",
      negatable: false,
    );
  }
  @override
  FutureOr<String>? run() => _createUseCase();

  @override
  String get description => "Creates a use case.";

  @override
  String get name => "use_case";

  String _createUseCase() {
    final bool isPart = argResults!["part"] as bool;
    final String useCaseNameRaw = argResults!.rest[0];

    final String libraryPath = _getLibPath("logic");
    final String useCasePath = _getPath("logic/use_cases", useCaseNameRaw, requiresImpl: false);

    final File libraryFile = File(libraryPath);
    final File useCaseFile = File(useCasePath);

    if (useCaseFile.existsSync()) {
      throw StateError("Use case file already exists.");
    }

    final List<String> libraryContent = <String>[];

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);

      libraryContent.addAll(<String>[
        "library;",
      ]);
    }

    if (isPart) {
      libraryContent.addAll(<String>[
        "",
        "part \"use_cases/$useCaseNameRaw.dart\";",
      ]);
    } else {
      libraryContent.addAll(<String>[
        "",
        "export \"use_cases/$useCaseNameRaw.dart\";",
      ]);
    }

    libraryFile.writeAsStringSync(
      libraryContent.join("\n"),
      mode: FileMode.append,
    );

    useCaseFile.createSync(recursive: true);

    final String useCaseName = _snakeToPascalCase(useCaseNameRaw);

    final List<String> fileContent = <String>[];

    if (isPart) {
      fileContent.addAll(<String>[
        "part of \"../../logic.dart\";",
        "",
      ]);
    }

    fileContent.addAll(<String>[
      "class ${useCaseName}UseCase {",
      "  Future<void> execute() async {}",
      "}",
      "",
    ]);

    useCaseFile.writeAsStringSync(fileContent.join("\n"));

    return "Use case file created at $useCasePath";
  }
}
