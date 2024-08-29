part of "command.dart";

class RouteCommand extends Command<String> {
  @override
  String get description => "Creates a new route for a Shelf server.";

  @override
  String get name => "route";

  @override
  FutureOr<String>? run() => _createRoute();

  String _createRoute() {
    final String routeNameRaw = argResults!.rest[0];
    final String routeName = _camelToPascalCase(routeNameRaw);

    final String libraryPath = _getLibPath("routes");
    final String routePath = _getPath("routes", routeNameRaw);

    final File libraryFile = File(libraryPath);
    final File routeFile = File(routePath);

    if (routeFile.existsSync()) {
      throw StateError("Route file already exists.");
    }

    if (!libraryFile.existsSync()) {
      libraryFile.createSync(recursive: true);
      libraryFile.writeAsStringSync(
        <String>[
          "library;",
          "",
          "export \"$routeNameRaw/$routeNameRaw.dart\";",
        ].join("\n"),
      );
    } else {
      libraryFile.writeAsStringSync(
        <String>[
          "",
          "export \"$routeNameRaw/$routeNameRaw.dart\";",
        ].join("\n"),
        mode: FileMode.append,
      );
    }

    routeFile.createSync(recursive: true);

    routeFile.writeAsStringSync(
      <String>[
        "import \"package:shelf/shelf.dart\";",
        "",
        "Future<Response> $routeName(Request req) {}",
        "",
      ].join("\n"),
    );

    return "Route file created at $routePath";
  }
}
