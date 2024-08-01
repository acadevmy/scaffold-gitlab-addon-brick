import 'package:mason/mason.dart';

import 'utils.dart';

void run(HookContext context) async {
  String pipelineSettingsUrl = context.vars['repositoryBaseUrl'] ?? '';
  if (!pipelineSettingsUrl.endsWith('/')) {
    pipelineSettingsUrl = '$pipelineSettingsUrl/';
  }
  pipelineSettingsUrl = '$pipelineSettingsUrl-/settings/ci_cd';

  final dotenvKeys = getDotenvKeys();

  context.logger.info(
    'Configure gitlab environment variables in $pipelineSettingsUrl:',
  );

  context.logger.success(
    '    - GL_TOKEN={valid gitlab token for semantic-release}',
  );
  context.logger.success(
    '    - DOTENV_KEY_CI=${dotenvKeys['ci'] ?? ''}',
  );
  context.logger.success(
    '    - DOTENV_KEY_STAGING=${dotenvKeys['staging'] ?? ''}',
  );
  context.logger.success(
    '    - DOTENV_KEY_PRODUCTION=${dotenvKeys['production'] ?? ''}',
  );

  final configureNow = context.logger.confirm(
    'do you want to open the configuration page to set these variables now?',
    defaultValue: true,
  );

  if (configureNow) {
    openUrl(pipelineSettingsUrl);
    bool finished = false;
    do {
      context.logger.confirm(
        'have you configured the variables?',
        defaultValue: false,
      );
    } while (!finished);
  }
}
