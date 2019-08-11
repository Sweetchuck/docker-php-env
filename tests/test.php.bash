#!/usr/bin/env bash

set -e

imageID="${1:?Required}"
phpVersionId="${2:?Required}"
phpHome="/root/.phpbrew/php/${phpVersionId}-nts"
# @todo The ${phpExecutable} variable should be a simple 'php'.
phpExecutable="${phpHome}/bin/php"

libDir=$(dirname $BASH_SOURCE)'/lib'

. "./${libDir}/assert.bash"
. "./${libDir}/docker.bash"


declare -A actual

message='php.version'
expectedStdOutput="${phpVersionId}"
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' "${phpExecutable}" '-r' 'echo PHP_VERSION_ID, PHP_EOL;'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='php.cli.extensions'
expectedStdOutput=$(cat "tests/expected/php.${phpVersionId:0:-2}-nts.cli.extensions.txt")
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' "${phpExecutable}" '-m'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='php.cli.extension.gd'
expectedStdOutput=$(cat "tests/expected/php.${phpVersionId:0:-2}-nts.cli.extension.gd.txt")
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' "${phpExecutable}" '-r ''echo yaml_emit(gd_info());'''
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='php.fpm-dev.extensions'
expectedStdOutput=$(cat "tests/expected/php.${phpVersionId:0:-2}-nts.fpm-dev.extensions.txt")
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' "${phpExecutable}" '-c' "${phpHome}/etc/php-fpm.d/php.dev.ini" '-m'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"

message='php.fpm-prod.extensions'
expectedStdOutput=$(cat "tests/expected/php.${phpVersionId:0:-2}-nts.fpm-prod.extensions.txt")
expectedStdError=''
expectedExitCode=0
dockerRun 'actual' "${phpExecutable}" '-c' "${phpHome}/etc/php-fpm.d/php.prod.ini" '-m'
assertEqualsString "${expectedStdOutput}" "${actual[stdOutput]}" "${message}.stdOutput"
assertEqualsString "${expectedStdError}"  "${actual[stdError]}"  "${message}.stdError"
assertEqualsNumber "${expectedExitCode}"  "${actual[exitCode]}"  "${message}.exitCode"
