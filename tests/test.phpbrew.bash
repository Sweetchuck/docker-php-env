#!/usr/bin/env bash

set -e

imageID="${1:?Required}"
phpbrewVersion="${2:?Required}"
phpbrewCli="${3:?Required}"

libDir=$(dirname $BASH_SOURCE)'/lib'

. "./${libDir}/assert.bash"
. "./${libDir}/docker.bash"

declare -A actual

message='phpbrewVersion'
expectedStdOutput=$(cat <<EOT
phpbrew - ${phpbrewVersion}
cliframework core: ${phpbrewCli}
EOT
)
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' 'phpbrew' '--version'
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"
