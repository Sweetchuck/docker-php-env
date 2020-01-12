##
## Hard-coded variables.
##
## You do not need to provide these variables from CLI.
## Usually these are default values for the optional variables.
##

SHELL=/bin/bash

# Manually updated latest stable PHP versions.
phpName704?=70401
phpName703?=70313
phpName702?=70226

# Manually updated latest stable NVM and NodeJS versions.
nodeVersion13?=13.6.0
yarnVersion13?=1.21.1

nodeVersion12?=12.14.0
yarnVersion12?=1.21.1

nodeVersion11?=11.15.0
yarnVersion11?=1.21.1


##
## Input variables.
##

vendor?=sweetchuck
aptCacherContainerName?=apt_cacher
ubuntuVersion?=19.04

phpbrewVersion?=1.24.1
phpbrewCli?=2.5.4

phpName?=${phpName704}

composerVersion?=1.9.1

nvmVersion?=0.35.2
nodeVersion?=${nodeVersion13}
yarnVersion?=${yarnVersion13}


##
## Calculated variables.
##

phpNameToVersion=sed \
	--regexp-extended \
	-e 's/^([[:digit:]])/\1./g' \
	-e 's/([[:digit:]][[:digit:]])$$/.\1/g' \
	-e 's/\.0/./g'

phpVersion=$(shell ${phpNameToVersion} <<<'${phpName}')
phpVersionMajorMinor=$(shell sed -e 's/..$$//g' <<<'${phpName}')

nodeVersionMajor=$(shell sed -e 's/\..*//g' <<<'${nodeVersion}')

imageTag?=${phpVersionMajorMinor}-${nodeVersionMajor}
imageTagParent?=${phpVersionMajorMinor}.x.x

aptCacherFormatHost?={{.NetworkSettings.IPAddress}}
aptCacherFormatPort?={{(index (index .NetworkSettings.Ports "3142/tcp") 0).HostPort}}

aptCacherHost=$(shell docker inspect '${aptCacherContainerName}' --format='${aptCacherFormatHost}' 2>/dev/null)
aptCacherPort=$(shell docker inspect '${aptCacherContainerName}' --format='${aptCacherFormatPort}' 2>/dev/null)
aptCacher=
ifneq ("${aptCacherHost}","")
	aptCacher:=http://${aptCacherHost}:${aptCacherPort}
endif

# Docker image IDs, except the ${vendor}/apt-cacher:latest.
imageIds=${vendor}/php-env-dev:4.x \
	${vendor}/php-env-base:4.x \
	${vendor}/php-env-dev:3.x \
	${vendor}/php-env-base:3.x \
	${vendor}/php-env-dev:2.x \
	${vendor}/php-env-base:2.x \
	${vendor}/php:$(shell ${phpNameToVersion} <<<'${phpName704}') \
	${vendor}/php:$(shell ${phpNameToVersion} <<<'${phpName703}') \
	${vendor}/php:$(shell ${phpNameToVersion} <<<'${phpName702}') \
	${vendor}/phpbrew:${phpbrewVersion} \
	${vendor}/node:${nodeVersion13} \
	${vendor}/node:${nodeVersion12} \
	${vendor}/node:${nodeVersion11} \
	${vendor}/nvm:${nvmVersion} \

helpTargetMaxCharNum= 20

.DEFAULT_GOAL=help

#https://gist.github.com/prwhite/8168133
help: help-prefix help-targets

help-prefix:
	@echo 'Syntax:'
	@echo '  make <target>'
	@echo '  make <target> [<varName>=<value>]'
	@echo '  varName=<value> make <target>'
	@echo ''

help-targets:
	@awk '/^[a-zA-Z0-9\-\_\.]+:/ \
		{ \
			helpMessage = match(lastLine, /^## (.+)/); \
			if (helpMessage) { \
				helpCommand = substr($$1, 0, index($$1, ":")-1); \
				helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
				helpGroup = match(helpMessage, /^@([^ ]*)/); \
				if (helpGroup) { \
					helpGroup = substr(helpMessage, RSTART + 1, index(helpMessage, " ")-2); \
					helpMessage = substr(helpMessage, index(helpMessage, " ")+1); \
				} \
				printf "%s|  %-$(helpTargetMaxCharNum)s %s\n", \
					helpGroup, helpCommand, helpMessage; \
			} \
		} \
		{ lastLine = $$0 }' \
		$(MAKEFILE_LIST) \
	| sort -t'|' -sk1,1 \
	| awk -F '|' ' \
			{ \
			cat = $$1; \
			if (cat != lastCat || lastCat == "") { \
				if ( cat == "0" ) { \
					print "Targets:" \
				} else { \
					gsub("_", " ", cat); \
					printf "Targets %s:\n", cat; \
				} \
			} \
			print $$2 \
		} \
		{ lastCat = $$1 }'


## @build Builds ${vendor}/phpbrew.
phpbrew.build:
	docker \
		build \
		--file		'./src/phpbrew/Dockerfile' \
		--tag		'${vendor}/phpbrew:${phpbrewVersion}' \
		--build-arg	'ubuntuVersion=${ubuntuVersion}' \
		--build-arg	'aptCacher=${aptCacher}' \
		--build-arg	'phpbrewVersion=${phpbrewVersion}' \
		./src/phpbrew/

	$(MAKE) phpbrew.test


## @test Runs some tests against the ${vendor}/phpbrew.
phpbrew.test:
	bash ./tests/test.phpbrew.bash \
		${vendor}/phpbrew:${phpbrewVersion} \
		${phpbrewVersion} \
		${phpbrewCli}


## @build Builds ${vendor}/php.
php.build:
	docker \
		build \
		--file		'./src/php/Dockerfile' \
		--tag		'${vendor}/php:${phpVersion}' \
		--build-arg	'vendor=${vendor}' \
		--build-arg	'phpbrewVersion=${phpbrewVersion}' \
		--build-arg	'phpName=${phpName}' \
		--build-arg	'phpVersion=${phpVersion}' \
		--build-arg	'phpVersionMajorMinor=${phpVersionMajorMinor}' \
		./src/php/

	$(MAKE) php.test phpName=${phpName}


## @test Runs some tests against the ${vendor}/php.
php.test:
	bash ./tests/test.php.${phpVersionMajorMinor}.bash \
		${vendor}/php:${phpVersion} \
		${phpName}


## @build Builds ${vendor}/nvm.
nvm.build:
	docker \
		build \
		--file		'./src/nvm/Dockerfile' \
		--tag		'${vendor}/nvm:${nvmVersion}' \
		--build-arg	'ubuntuVersion=${ubuntuVersion}' \
		--build-arg 'aptCacher=${aptCacher}' \
		--build-arg	'nvmVersion=${nvmVersion}' \
		./src/nvm/

	$(MAKE) nvm.test nvmVersion=${nvmVersion}


## @test Runs some tests against the ${vendor}/nvm.
nvm.test:
	bash ./tests/test.nvm.bash \
		${vendor}/nvm:${nvmVersion} \
		${nvmVersion}


## @build Builds ${vendor}/node.
node.build:
	docker \
		build \
		--file		'./src/node/Dockerfile' \
		--tag		'${vendor}/node:${nodeVersion}' \
		--build-arg	'vendor=${vendor}' \
		--build-arg	'nvmVersion=${nvmVersion}' \
		--build-arg	'nodeVersion=${nodeVersion}' \
		--build-arg	'yarnVersion=${yarnVersion}' \
		./src/nvm/

	$(MAKE) node.test nodeVersion=${nodeVersion}


## @test Runs some tests against the ${vendor}/node.
node.test:
	bash ./tests/test.node.${nodeVersionMajor}.bash \
		'${vendor}/node:${nodeVersion}' \
		'${nodeVersion}'


## @build Builds ${vendor}/php-env-base.
php-env-base.build:
	docker \
		build \
		--file		'./src/php-env-base/Dockerfile' \
		--tag		'${vendor}/php-env-base:${imageTag}' \
		--build-arg	'vendor=${vendor}' \
		--build-arg	'phpVersion=${phpVersion}' \
		--build-arg	'phpName=${phpName}' \
		./src/php-env-base/

	$(MAKE) php-env-base.test \
		imageTag=${imageTag} \
		phpVersion=${phpVersion} \
		phpName=${phpName}


php-env-base.test:
	bash ./tests/test.php-env-base.${phpVersionMajorMinor}.bash \
		'${vendor}/php-env-base:${imageTag}' \
		'${phpVersion}' \
		'${phpName}'


php-env-dev.dockerfile:
	# @todo https://github.com/moby/moby/issues/34482
	$(shell \
		sed \
			src/php-env-dev/Dockerfile \
			--expression 's/\$${nvmVersion}/${nvmVersion}/g' \
			--expression 's/\$${nodeVersion}/${nodeVersion}/g' \
			> src/php-env-dev/Dockerfile.nvm${nvmVersion}-node${nodeVersion} \
	)

## @build Builds ${vendor}/php-env-dev.
php-env-dev.build:
	$(MAKE) php-env-dev.dockerfile \
		nvmVersion=${nvmVersion} \
		nodeVersion=${nodeVersion}

	docker \
		build \
		--file		'./src/php-env-dev/Dockerfile.nvm${nvmVersion}-node${nodeVersion}' \
		--tag		'${vendor}/php-env-dev:${imageTag}' \
		--build-arg	'vendor=${vendor}' \
		--build-arg	'imageTagParent=${imageTagParent}' \
		--build-arg	'nvmVersion=${nvmVersion}' \
		--build-arg	'nodeVersion=${nodeVersion}' \
		--build-arg	'composerVersion=${composerVersion}' \
		./src/php-env-dev/

	$(MAKE) php-env-dev.test \
		imageTag=${imageTag} \
		phpVersion=${phpVersion} \
		phpName=${phpName}

	$(MAKE) php-env-dev.readme \
		imageId=${vendor}/php-env-dev:${imageTag}


php-env-dev.test:
	bash ./tests/test.php-env-dev.${phpVersionMajorMinor}-${nodeVersionMajor}.bash \
		'${vendor}/php-env-dev:${imageTag}' \
		'${phpVersion}' \
		'${phpName}' \
		'${nodeVersion}'

php-env-dev.readme:
	$(shell mkdir -p "build/$$(dirname ${imageId})")
	$(shell imageId="${imageId}" ${SHELL} ./src/php-env-dev/README.md.bash > 'build/${imageId}.md')


## @other Deletes all the Docker containers and Docker images, except the apt-cacher related ones.
clean:
	@- $(foreach imageId,$(imageIds), \
		containerIds=$(shell docker ps --all --quiet --filter='ancestor=${imageId}'); \
		test "${containerIds}" == '' || docker stop "${containerIds}"; \
		test "${containerIds}" == '' || docker rm   "${containerIds}"; \
		test "$(shell docker images --quiet ${imageId})" == '' || docker image rm "${imageId}"; \
	)


## @build Everything
build.php-env:
	$(MAKE) phpbrew.build \
		ubuntuVersion=${ubuntuVersion} \
		vendor=${vendor} \
		aptCacher=${aptCacher} \
		phpbrewVersion=${phpbrewVersion}

	$(MAKE) php.build \
		vendor=${vendor} \
		aptCacher=${aptCacher} \
		phpbrewVersion=${phpbrewVersion} \
		phpName=${phpName}

	$(MAKE) nvm.build \
		ubuntuVersion=${ubuntuVersion} \
		vendor=${vendor} \
		aptCacher=${aptCacher} \
		nvmVersion=${nvmVersion}

	$(MAKE) node.build \
		vendor=${vendor} \
		nvmVersion=${nvmVersion} \
		nodeVersion=${nodeVersion} \
		yarnVersion=${yarnVersion}

	$(MAKE) php-env-base.build \
		vendor=${vendor} \
		phpName=${phpName} \
		imageTag=${phpVersionMajorMinor}.x.x

	$(MAKE) php-env-dev.build \
		vendor=${vendor} \
		imageTagParent=${phpVersionMajorMinor}.x.x \
		nvmVersion=${nvmVersion} \
		nodeVersion=${nodeVersion} \
		composerVersion=${composerVersion} \
		imageTag=${phpVersionMajorMinor}-${nodeVersionMajor}.x.x
