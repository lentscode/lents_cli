part of "command.dart";

/// Command to create files and folders.
class CreateCommand extends Command<String> {
  /// Creates an instance of [CreateCommand] and initializes subcommands.
  CreateCommand() {
    addSubcommand(ModelCommand());
    addSubcommand(UseCaseCommand());
  }

  @override
  String get description => "Create files and folders.";

  @override
  String get name => "create";
}
