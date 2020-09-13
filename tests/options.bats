#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# fallback in case command is accidentally run
export CONVOX_HOST="convox.invalid"

# simplest possible configuration
export BUILDKITE_PLUGIN_CONVOX_RUN_RACK="test-rack"
export BUILDKITE_PLUGIN_CONVOX_RUN_APP="test-app"
export BUILDKITE_PLUGIN_CONVOX_RUN_SERVICE="web"
export BUILDKITE_PLUGIN_CONVOX_RUN_COMMAND="bash -ec 'echo \"Hello, world!\"'"

subject() {
  "$PWD/hooks/command" >&3 2>&3
}

@test "Runs the run command with minimal required configuration" {
  # TODO: validate command
  stub convox "run --rack=test-rack --app=test-app web : echo 'Hello, world!'"

  subject

  unstub convox
}

@test "Supports detach" {
  stub convox "run --rack=test-rack --app=test-app --detach web : true"

  BUILDKITE_PLUGIN_CONVOX_RUN_DETACH="true" \
    subject

  unstub convox
}

@test "Supports timeout" {
  stub convox "run --rack=test-rack --app=test-app --timeout=600 web : echo 'Hello, world!'"

  BUILDKITE_PLUGIN_CONVOX_RUN_TIMEOUT="600" \
    subject

  unstub convox
}

@test "Supports release string" {
  stub convox "run --rack=test-rack --app=test-app --release=TESTRELEASE web : echo 'Hello, world!'"

  BUILDKITE_PLUGIN_CONVOX_RUN_RELEASE="TESTRELEASE" \
    subject

  unstub convox
}

@test "Supports release from meta-data" {
  stub convox "run --rack=test-rack --app=test-app --release=FAKERELEASE web : echo 'Hello, world!'"
  stub buildkite-agent "meta-data get convox-release-id : echo 'FAKERELEASE'"

  BUILDKITE_PLUGIN_CONVOX_RUN_RELEASE_METADATA_KEY="convox-release-id" \
    subject

  unstub convox
  unstub buildkite-agent
}
