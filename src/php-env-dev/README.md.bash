#!/bin/bash

: "${imageId:?required}"

dockerRun=(
	docker
	run
	--rm
	'--entrypoint' ''
	--tty
	--interactive
	"${imageId}"
	/bin/bash
	--login
	-c
)

osVersionCmd="cat /etc/os-release"
osVersion="$("${dockerRun[@]}" "${osVersionCmd}" | grep 'VERSION=')"

phpVersionCmd='php --version'
phpVersion=$("${dockerRun[@]}" "${phpVersionCmd}")

phpModulesCmd='php -m'
phpModules=$("${dockerRun[@]}" "${phpModulesCmd}")

composerVersionCmd='composer --version --no-ansi'
composerVersion=$("${dockerRun[@]}" "${composerVersionCmd}")

nvmListCmd='nvm list --no-colors'
nvmList=$("${dockerRun[@]}" "${nvmListCmd}")

yarnVersionCmd='nvm use stable && yarn --version'
yarnVersion=$("${dockerRun[@]}" "${yarnVersionCmd}")

chromiumVersionCmd='chromium-browser --version'
chromiumVersion=$("${dockerRun[@]}" "${chromiumVersionCmd}")

prompt='root@localhost:~#'
code='```'
cat <<EOT
## ${imageId}

${code}
${prompt} ${osVersionCmd} | grep 'VERSION='
${osVersion}
${code}

${code}
${prompt} ${phpVersionCmd}
${phpVersion}
${code}

${code}
${prompt} ${phpModulesCmd}
${phpModules}
${code}

${code}
${prompt} ${composerVersionCmd}
${composerVersion}
${code}

${code}
${prompt} ${nvmListCmd}
${nvmList}
${code}

${code}
${prompt} ${yarnVersionCmd}
${yarnVersion}
${code}

${code}
${prompt} ${chromiumVersionCmd}
${chromiumVersion}
${code}

EOT
