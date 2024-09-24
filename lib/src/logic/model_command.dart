part of "command.dart";

/// Command to create a model.
class ModelCommand extends Command<String> {
  @override
  String get description =>
      "Creates a model, with an abstract class and an implementation class.";

  @override
  String get name => "model";

  @override
  FutureOr<String>? run() => _createModel();

  String _createModel() {
    final String modelNameRaw = argResults!.rest[0];

    final String libraryPath = _getLibPath("models");
    final String modelPath = _getPath("models", modelNameRaw);
    final String modelImplPath = _getImplPath("models", modelNameRaw);

    final File libraryFile = File(libraryPath);
    final File modelFile = File(modelPath);
    final File modelImplFile = File(modelImplPath);

    if (modelFile.existsSync() || modelImplFile.existsSync()) {
      throw StateError("Model or implementation file already exists.");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>[
          "export \"$modelNameRaw/$modelNameRaw.dart\";",
        ].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          "export \"$modelNameRaw/$modelNameRaw.dart\";",
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    modelFile.createSync(recursive: true);
    modelImplFile.createSync(recursive: true);

    final String modelName = _snakeToPascalCase(modelNameRaw);

    modelFile.writeAsStringSync(
      <String>[
        "part \"$modelNameRaw.impl.dart\";",
        "",
        "abstract class $modelName {",
        "  $modelName._();",
        "",
        "  factory $modelName() = _${modelName}Impl;",
        "}",
        ""
      ].join("\n"),
    );

    modelImplFile.writeAsStringSync(
      <String>[
        "part of \"$modelNameRaw.dart\";",
        "",
        "class _${modelName}Impl extends $modelName {",
        "  _${modelName}Impl() : super._();",
        "}",
        ""
      ].join("\n"),
    );
    return "Model file created at $modelPath";
  }
}
