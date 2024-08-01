import 'dart:io';

Map<String, String?> extractGroupAndProject(String url) {
  final pattern = RegExp(
      r'(?:(?:git@|https:\/\/)gitlab\.com[:\/])?(?:(?<group>[^\/]+)\/)?(?<project>[^\/]+)\.git');
  final match = pattern.firstMatch(url);

  if (match != null) {
    final group = match.namedGroup('group');
    final project = match.namedGroup('project');
    return {'group': group, 'project': project};
  }

  return {'group': null, 'project': null};
}

String convertToHttpsRepositoryUrl(String url) {
  final extracted = extractGroupAndProject(url);
  final group = extracted['group'];
  final project = extracted['project'];

  if (group != null) {
    return 'https://gitlab.com/$group/$project';
  } else if (project != null) {
    return 'https://gitlab.com/$project';
  } else {
    throw ArgumentError('Invalid GitLab URL');
  }
}

Future<void> openUrl(String url) async {
  try {
    if (Platform.isWindows) {
      await Process.start('start', [url]);
    } else if (Platform.isMacOS) {
      await Process.start('open', [url]);
    } else if (Platform.isLinux) {
      await Process.start('xdg-open', [url]);
    } else {
      throw Exception('Unsupported platform');
    }
  } catch (_) {
    print('navigate to $url');
  }
}

Map<String, String> getDotenvKeys() {
  final dotenvVaultKeysResult = Process.runSync(
    'pnpm',
    [
      'dlx',
      'dotenv-vault',
      'keys',
    ],
  );

  final dotenvVaultRawResponse = dotenvVaultKeysResult.stdout.toString().trim();

  final Map<String, String> dotenvKeys = {};

  // Espressione regolare per estrarre l'ambiente e la chiave
  final RegExp exp = RegExp(
      r'(\w+)\s+dotenv://:(key_[a-f0-9]+)@dotenv\.org/vault/.env\.vault\?environment=\1');

  // Trova tutte le corrispondenze nella stringa di input
  final matches = exp.allMatches(dotenvVaultRawResponse);

  for (final match in matches) {
    final environment = match.group(1);
    final key = match.group(2);
    if (environment != null && key != null) {
      dotenvKeys[environment.toLowerCase()] =
          'dotenv://:$key@dotenv.org/vault/.env.vault?environment=$environment';
    }
  }

  return dotenvKeys;
}
