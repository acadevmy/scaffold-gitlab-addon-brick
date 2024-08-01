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

  context.logger.warn(
    'Configure gitlab environment variables:\n',
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

  await openUrl(pipelineSettingsUrl);
}
