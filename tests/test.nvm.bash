#!/usr/bin/env bash

set -e

imageID="${1:?Required}"
nvmVersion="${2:?Required}"

libDir=$(dirname $BASH_SOURCE)'/lib'

. "./${libDir}/assert.bash"
. "./${libDir}/docker.bash"

declare -A actual

message='nvmVersion'
expectedStdOutput="${nvmVersion}"
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' '/bin/bash' '--login' '-c' 'nvm --version'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='nvmList'
expectedStdOutput=$(cat <<'EOT'
            N/A
iojs -> N/A (default)
node -> stable (-> N/A) (default)
unstable -> N/A (default)
EOT
)
expectedStdError=''
expectedExitCode=3
dockerRun 'actual' '/bin/bash' '--login' '-c' 'nvm list --no-colors'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"
