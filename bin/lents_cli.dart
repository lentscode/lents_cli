import "package:args/command_runner.dart";
import "package:lents_cli/lents_cli.dart";

void main(List<String> arguments) {
  final CommandRunner<String> command =
      CommandRunner<String>("lents", "A helper to create files and folders")
        ..addCommand(DataSourceCommand())
        ..addCommand(ExceptionCommand())
        ..addCommand(ModelCommand())
        ..addCommand(UseCaseCommand())
        ..addCommand(RouteCommand())
        ..addCommand(CubitCommand());

  command.run(arguments);
}
