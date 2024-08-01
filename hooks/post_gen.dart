import 'package:mason/mason.dart';
import 'package:dolumns/dolumns.dart';
import 'utils.dart';

void run(HookContext context) async {
  String pipelineSettingsUrl = context.vars['repositoryBaseUrl'] ?? '';
  if (!pipelineSettingsUrl.endsWith('/')) {
    pipelineSettingsUrl = '$pipelineSettingsUrl/';
  }
  pipelineSettingsUrl = '$pipelineSettingsUrl-/settings/ci_cd';

  final dotenvKeys = getDotenvKeys();

  context.logger.info(
    'Configure gitlab environment variables:',
  );

  context.logger.info(dolumnify(
    [
      ['VARIABLE', 'VALUE'],
      ['GL_TOKEN', ''],
      ['DOTENV_KEY_CI', dotenvKeys['ci'] ?? ''],
      ['DOTENV_KEY_STAGING', dotenvKeys['staging'] ?? ''],
      ['DOTENV_KEY_PRODUCTION', dotenvKeys['production'] ?? ''],
    ],
    columnSplitter: ' | ',
    headerIncluded: true,
    headerSeparator: '=',
  ));
  context.logger.success(
    'GL_TOKEN={valid gitlab token for semantic-release}',
  );

  final configureNow = context.logger.confirm(
    'do you want to open the configuration page to set these variables now?',
    defaultValue: true,
  );

  if (configureNow) {
    openUrl(pipelineSettingsUrl);
    bool finished = false;
    do {
      finished = context.logger.confirm(
        'have you configured the variables?',
        defaultValue: false,
      );
    } while (!finished);
  }
}
