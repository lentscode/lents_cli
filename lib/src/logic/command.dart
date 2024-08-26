library;

import "dart:async";
import "dart:io";

import "package:args/command_runner.dart";

part "create_command.dart";
part "data_source_command.dart";
part "model_command.dart";
part "use_case_command.dart";

/// Base directory of the project.
String baseDirectory = "${Directory.current.path}/lib/src";

extension _PrivateExtensions on Command {
  String _getPath(String folder, String name) =>
      "$baseDirectory/$folder/$name/$name.dart";

  String _getImplPath(String folder, String name) =>
      "$baseDirectory/$folder/$name/$name.impl.dart";

  String _snakeToPascalCase(String input) =>
      input.split("_").map((String word) {
        if (word.isEmpty) return "";
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join();
}
