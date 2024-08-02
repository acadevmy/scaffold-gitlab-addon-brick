import 'package:mason/mason.dart';
import 'package:dolumns/dolumns.dart';
import 'constants.dart';
import 'utils.dart';

void run(HookContext context) async {
  final dotenvKeys = getDotenvKeys();

  context.logger.warn(
    '📚 Remember to configure these Gitlab CI/CD variables:\n',
  );

  context.logger.info(dolumnify(
    [
      ['VARIABLE', 'VALUE'],
      ['GL_TOKEN', 'ask it to your master :)'],
      ['DOTENV_KEY_CI', dotenvKeys['ci'] ?? ''],
      ['DOTENV_KEY_STAGING', dotenvKeys['staging'] ?? ''],
      ['DOTENV_KEY_PRODUCTION', dotenvKeys['production'] ?? ''],
    ],
    columnSplitter: ' | ',
    headerIncluded: true,
    headerSeparator: '=',
  ));

  context.logger.write('\n');

  final configureItNow = context.logger.confirm(
    '📚 do you want to setup gitlab variables now?',
    defaultValue: true,
  );

  if (configureItNow) {
    String pipelineSettingsUrl = getPipelineSettingsUrl(
      context.vars[REPOSITORY_BASE_URL] ?? '',
    );

    await openUrl(pipelineSettingsUrl);
    context.logger
        .prompt('press any key after completing setup to continue...');
  }

  context.logger.write('\n');
}
