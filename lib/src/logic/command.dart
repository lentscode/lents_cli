library;

import "dart:async";
import "dart:io";

import "package:args/command_runner.dart";

part "cubit_command.dart";
part "data_source_command.dart";
part "exception_command.dart";
part "model_command.dart";
part "route_command.dart";
part "use_case_command.dart";

/// Base directory of the project.
String baseDirectory = "${Directory.current.path}/lib/src";

extension _PrivateExtensions on Command {
  String _getPath(
    String folder,
    String name, {
    bool requiresImpl = true,
    String? superFolder,
  }) =>
      requiresImpl
          ? "$baseDirectory/$folder/${superFolder ?? name}/$name.dart"
          : "$baseDirectory/$folder/$name.dart";

  String _getImplPath(
    String folder,
    String name, {
    String? superFolder,
  }) =>
      "$baseDirectory/$folder/${superFolder ?? name}/$name.impl.dart";

  String _getLibPath(String folder) => "$baseDirectory/$folder/$folder.dart";

  String _snakeToPascalCase(String input) =>
      input.split("_").map((String word) {
        if (word.isEmpty) return "";
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join();

  String _camelToPascalCase(String input) {
    String output = "";

    final List<String> words = input.split("_");

    for (int i = 0; i < words.length; i++) {
      if (words[i].isEmpty) continue;

      if (i == 0) {
        output += words[i].toLowerCase();
      } else {
        output +=
            words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }

    return output;
  }
}
