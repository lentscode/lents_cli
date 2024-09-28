part of "command.dart";

class CubitCommand extends Command<String> {
  @override
  String get description => "Creates a cubit.";

  @override
  String get name => "cubit";

  @override
  FutureOr<String>? run() => _createCubit();

  String _createCubit() {
    final String cubit = argResults!.rest[0];

    final String cubitNameRaw = "${cubit}_cubit";
    final String stateNameRaw = "${cubit}_state";

    final String cubitName = _snakeToPascalCase(cubit);

    final String libraryPath = _getLibPath("state");
    final String cubitPath = _getPath(
      "state",
      cubitNameRaw,
      superFolder: cubit,
    );
    final String statesPath = _getPath(
      "state",
      stateNameRaw,
      superFolder: cubit,
    );
    final String cubitImplPath = _getImplPath(
      "state",
      cubitNameRaw,
      superFolder: cubit,
    );

    final File libraryFile = File(libraryPath);
    final File cubitFile = File(cubitPath);
    final File cubitImplFile = File(cubitImplPath);
    final File stateFile = File(statesPath);

    if (cubitFile.existsSync() ||
        cubitImplFile.existsSync() ||
        stateFile.existsSync()) {
      throw StateError("Cubit already exists!");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>[
          'export "$cubit/$cubitNameRaw.dart";',
        ].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          'export "$cubit/$cubitNameRaw.dart";',
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    cubitFile.createSync(recursive: true);
    cubitImplFile.createSync(recursive: true);
    stateFile.createSync(recursive: true);

    cubitFile.writeAsStringSync(
      <String>[
        'import "package:bloc/bloc.dart";',
        'import "package:flutter/material.dart";',
        "",
        'part "$stateNameRaw.dart";',
        'part "$cubitNameRaw.impl.dart";',
        "",
        "abstract class ${cubitName}Cubit extends Cubit<${cubitName}State> {",
        "  ${cubitName}Cubit._() : super(${cubitName}Initial());",
        "",
        "  factory ${cubitName}Cubit() = _${cubitName}Cubit;",
        "}",
        "",
      ].join("\n"),
    );

    cubitImplFile.writeAsStringSync(
      <String>[
        'part of "$cubitNameRaw.dart";',
        "",
        "class _${cubitName}Cubit extends ${cubitName}Cubit {",
        "  _${cubitName}Cubit() : super._();",
        "}"
      ].join("\n"),
    );

    stateFile.writeAsStringSync(
      <String>[
        'part of "$cubitNameRaw.dart";',
        "",
        "@immutable",
        "sealed class ${cubitName}State {}",
        "",
        "final class ${cubitName}Initial extends ${cubitName}State {}",
        "",
      ].join("\n"),
    );

    return "Cubit created";
  }
}
