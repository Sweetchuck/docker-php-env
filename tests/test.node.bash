#!/usr/bin/env bash

set -e

imageID="${1:?Required}"
nodeVersion="${2:?Required}"

libDir=$(dirname $BASH_SOURCE)'/lib'

. "./${libDir}/assert.bash"
. "./${libDir}/docker.bash"

declare -A actual

message='whichNode'
expectedStdOutput="/root/.nvm/versions/node/v${nodeVersion}/bin/node"
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' '/bin/bash' '--login' '-c' 'which node'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='nodeVersion'
expectedStdOutput="v${nodeVersion}"
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' '/bin/bash' '--login' '-c' 'node --version'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='yarnVersion'
expectedStdOutput='^[0-9]+\.[0-9]+\.[0-9]+($|-)'
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' '/bin/bash' '--login' '-c' 'yarn --version'
assertPregMatch    "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"
