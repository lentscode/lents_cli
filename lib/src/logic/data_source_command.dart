part of "command.dart";

class DataSourceCommand extends Command<String> {
  @override
  String get description =>
      "Creates a new data source, with an abstract class and an implementation.";

  @override
  String get name => "data_source";

  @override
  FutureOr<String>? run() => _createDataSource();

  String _createDataSource() {
    final String dataSourceNameRaw = "${argResults!.rest[0]}_data_source";

    final String libraryPath = _getLibPath("data");
    final String dataSourcePath = _getPath("data", dataSourceNameRaw);
    final String dataSourceImplPath = _getImplPath("data", dataSourceNameRaw);

    final File libraryFile = File(libraryPath);
    final File dataSourceFile = File(dataSourcePath);
    final File dataSourceImplFile = File(dataSourceImplPath);

    if (dataSourceFile.existsSync() || dataSourceImplFile.existsSync()) {
      throw StateError("Model or implementation file already exists.");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>[
          "library;",
          "",
          "export \"$dataSourceNameRaw/$dataSourceNameRaw.dart\";",
        ].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          "export \"$dataSourceNameRaw/$dataSourceNameRaw.dart\";",
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    dataSourceFile.createSync(recursive: true);
    dataSourceImplFile.createSync(recursive: true);

    final String dataSourceName = _snakeToPascalCase(dataSourceNameRaw);

    dataSourceFile.writeAsStringSync(
      <String>[
        "part \"$dataSourceNameRaw.impl.dart\";",
        "",
        "abstract class $dataSourceName {",
        "  $dataSourceName._();",
        "",
        "  factory $dataSourceName() = _${dataSourceName}Impl;",
        "}",
        ""
      ].join("\n"),
    );

    dataSourceImplFile.writeAsStringSync(
      <String>[
        "part of \"$dataSourceNameRaw.dart\";",
        "",
        "class _${dataSourceName}Impl extends $dataSourceName {",
        "  _${dataSourceName}Impl() : super._();",
        "}",
        ""
      ].join("\n"),
    );
    return "DataSource file created at $dataSourcePath";
  }
}
