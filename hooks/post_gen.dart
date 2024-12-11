import 'package:mason/mason.dart';
import 'package:dolumns/dolumns.dart';
import 'constants.dart';
import 'utils.dart';

void run(HookContext context) async {
  final dotenvKeys = getDotenvKeys();
  final repositoryBaseUrl = context.vars[REPOSITORY_BASE_URL] ?? '';

  final defaultBranchSettingsUrl = getBranchDefaultSettingsUrl(
    repositoryBaseUrl,
  );
  final mergeRequestSettingsUrl = getMergeRequestSettingsUrl(
    repositoryBaseUrl,
  );
  final pipelineSettingsUrl = getPipelineSettingsUrl(
    repositoryBaseUrl,
  );
  final protectedBranchesSettingsUrl = getProtectedBranchesSettingsUrl(
    repositoryBaseUrl,
  );
  final pipelineVariables = dolumnify(
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
  );

  final protectedBranchesVariables = dolumnify(
    [
      ['BRANCH', 'MERGE', 'PUSH/MERGE', 'FORCE PUSH'],
      ['*.x', 'Maintainers', 'Maintainers', 'false'],
      ['next', 'Maintainers', 'Maintainers', 'false'],
      ['next-major', 'Maintainers', 'Maintainers', 'false'],
      ['main', 'Maintainers', 'Maintainers', 'false'],
    ],
    columnSplitter: ' | ',
    headerIncluded: true,
    headerSeparator: '=',
  );

  final mergeRequestVariables = dolumnify(
    [
      ['OPTION', 'VALUE'],
      ['merge method', 'fast-forward merge'],
      ['squash commmits', 'require'],
      ['merge checks', 'pipeline must succeed'],
      ['merge checks', 'all thread must resolve'],
    ],
    columnSplitter: ' | ',
    headerIncluded: true,
    headerSeparator: '=',
  );

  final manualSteps = [
"""
(1/4) Set main as default branch
$defaultBranchSettingsUrl
""",
"""
(2/4) Configure protected branches
$protectedBranchesSettingsUrl

$protectedBranchesVariables
""",
"""
(3/4) Configure Merge Requests
$mergeRequestSettingsUrl

$mergeRequestVariables
""",
"""
(4/4) Configure Gitlab CI/CD Variables
$pipelineSettingsUrl

$pipelineVariables
""",
  ];

  context.logger.info("📚 Next steps to follow:\n");

  for (final step in manualSteps) {
    context.logger.info(step);
    context.logger.info('\n');
    context.logger.prompt('press any key after completing setup to continue...');
  }

  context.logger.write('\n');
}
