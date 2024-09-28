part of "command.dart";

class LogicCommand extends Command<String> {
  @override
  String get description => "Creates a logic class.";

  @override
  String get name => "logic";

  @override
  FutureOr<String>? run() => _createLogic();

  String _createLogic() {
    final String logicNameRaw = argResults!.rest[0];

    final String libraryPath = _getLibPath("logic");
    final String logicPath = _getPath("logic", logicNameRaw);
    final String logicImplPath = _getImplPath("logic", logicNameRaw);

    final File libraryFile = File(libraryPath);
    final File logicFile = File(logicPath);
    final File logicImplFile = File(logicImplPath);

    if (logicFile.existsSync() || logicImplFile.existsSync()) {
      throw StateError("Logic or implementation file already exist.");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>['export "$logicNameRaw/$logicNameRaw.dart";'].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          'export "$logicNameRaw/$logicNameRaw.dart";',
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    logicFile.createSync(recursive: true);
    logicImplFile.createSync();

    final String logicName = _snakeToPascalCase(logicNameRaw);

    logicFile.writeAsStringSync(
      <String>[
        'part "$logicNameRaw.impl.dart";',
        "",
        "abstract class $logicName {",
        "  $logicName._();",
        "",
        "  factory $logicName() = _$logicName;",
        "}",
      ].join("\n"),
    );

    logicImplFile.writeAsStringSync(
      <String>[
        'part of "$logicNameRaw.dart";',
        "",
        "class _$logicName extends $logicName {",
        "  _$logicName() : super._();",
        "}",
      ].join("\n"),
    );

    return "Logic class created.";
  }
}
