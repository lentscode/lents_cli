part of "command.dart";

class ExceptionCommand extends Command<String> {
  @override
  String get description => "Creates a new exception class.";

  @override
  String get name => "exception";

  @override
  FutureOr<String>? run() => _createException();

  String _createException() {
    final String exceptionNameRaw = argResults!.rest[0];
    final String exceptionName = _snakeToPascalCase(exceptionNameRaw);

    final String exceptionPath = "$baseDirectory/exceptions/exceptions.dart";

    final File exceptionFile = File(exceptionPath);

    if (!exceptionFile.existsSync()) {
      exceptionFile
        ..createSync(recursive: true)
        ..writeAsString(<String>[
          "class ${exceptionName}Exception implements Exception {}",
        ].join("\n"));
    } else {
      exceptionFile.writeAsStringSync(
        <String>[
          "",
          "class ${exceptionName}Exception implements Exception {}",
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    return "Exception file created at $exceptionPath";
  }
}
