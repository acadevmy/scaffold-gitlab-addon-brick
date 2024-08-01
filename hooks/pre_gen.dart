import 'dart:io';

import 'package:mason/mason.dart';

import 'utils.dart';

void run(HookContext context) {
  configureGitlabBaseUrl(context);

  Process.runSync(
    'pnpm',
    [
      'install -D @semantic-release/gitlab -w',
    ],
  );
}

void configureGitlabBaseUrl(HookContext context) {
  context.vars.putIfAbsent('repositoryBaseUrl', () {
    final processResult = Process.runSync(
      'git',
      [
        'config --get remote.origin.url',
      ],
    );

    final configuredGitUrl = processResult.stdout.toString().trim();
    String url = configuredGitUrl;

    while (!url.startsWith('https://') && !url.startsWith('git@gitlab')) {
      context.logger.err('Cannot find valid repository url!');
      url = context.logger
          .prompt(
              'Insert a valid gitlab repository clone https/ssh url (ex. https://gitlab.com/pillar-1/devops.git)')
          .trim();
    }

    if (url != configuredGitUrl) {
      Process.runSync(
        'git',
        [
          'remote add origin $url',
        ],
      );
    }

    return convertToHttpsRepositoryUrl(url);
  });
}
