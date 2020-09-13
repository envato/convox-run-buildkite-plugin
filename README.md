# Convox Run Buildkite Plugin [![Changelog](https://img.shields.io/badge/-Changelog-blue)](./CHANGELOG.md)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) that can run commands in Convox services

- Convox run is triggered via the Convox CLI (`convox run`)
- Release IDs can be passed or retrieved from metadata

## Example

The following pipeline will build a new release, run migrations, then promote the release for the `test-app` app in the `test-rack` rack.

```yaml
steps:
  - plugins:
    - liamdawson/convox-build#v1.0.0:
        rack: test-rack
        app: test-app
        metadata:
          release-id: convox-release-id
  
  - wait:

  - plugins:
    - liamdawson/convox-run#v1.0.0:
        rack: test-rack
        app: test-app
        service: web
        command: "/app/bin/rake db:migrate"
        timeout: 300 # 5 minutes
        release:
          metadata-key: convox-release-id

  - wait:

  - plugins:
    - liamdawson/convox-promote#v1.0.0:
        rack: test-rack
        app: test-app
        wait: false
        release:
          metadata-key: convox-release-id
```
