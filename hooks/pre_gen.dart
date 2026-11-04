import 'dart:io';

import 'package:mason/mason.dart';

import 'constants.dart';
import 'utils.dart';

void run(HookContext context) {
  configureGitlabBaseUrl(context);

  Process.runSync(
    'pnpm',
    [
      'install', '-D', '@semantic-release/gitlab', '-w',
    ],
  );
}

void configureGitlabBaseUrl(HookContext context) {
  context.vars.putIfAbsent(REPOSITORY_BASE_URL, () {
    final processResult = Process.runSync(
      'git',
      [
        'config', '--get', 'remote.origin.url',
      ],
    );

    final configuredGitUrl = processResult.stdout.toString().trim();
    String url = configuredGitUrl;

    while (!url.startsWith('http') && !url.startsWith('git@gitlab')) {
      if (isNonInteractive(context)) {
        throw Exception(
            'Cannot find valid repository url! Pass --var $REPOSITORY_BASE_URL=<https or ssh gitlab url> (ex. https://gitlab.com/my-wonderful-project.git)');
      }
      context.logger.err('📚 Cannot find valid repository url!');
      url = context.logger
          .prompt(
              '📚 Insert a valid gitlab repository clone https/ssh url (ex. https://gitlab.com/my-wonderful-project.git)')
          .trim();
    }

    if (url != configuredGitUrl) {
      context.logger.info('📚 git remote add origin $url');
      Process.runSync(
        'git',
        [
          'remote', 'add', 'origin', url,
        ],
      );
    }

    return convertToHttpsRepositoryUrl(url);
  });
}
