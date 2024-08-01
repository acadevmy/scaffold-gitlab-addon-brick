const { env } = require('@dotenv-run/core');

env({
  files: ['.env.vault'],
});

/**
 * @type {import('semantic-release').GlobalConfig}
 */
const releaseConfig = {
  branches: ["main"],
  plugins: [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    ["@semantic-release/gitlab", { assets: ["CHANGELOG.md"] }],
    [
      "@semantic-release/exec",
      {
        prepareCmd: "pnpm version ${nextRelease.version} --allow-same-version --no-commit-hooks --no-git-tag-version -ws --no-workspaces-update",
      },
    ],
    [
      "@semantic-release/git",
      {
        assets: [
          "CHANGELOG.md",
          "package.json",
          "package-lock.json",
          "applications/**/package.json",
          "libraries/**/pnpm-lock.yaml"
        ],
        message:
          "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
      },
    ],
  ],
};

module.exports = releaseConfig;