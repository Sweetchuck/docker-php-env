ARG vendor=sweetchuck
ARG imageTagParent=704-13.x.x
FROM ${vendor}/php-env-base:${imageTagParent}

RUN DEBIAN_FRONTEND='noninteractive' \
	apt-get update -y \
	&& \
	DEBIAN_FRONTEND='noninteractive' \
	apt-get install -y \
		chromium-browser \
		chromium-chromedriver \
	&& \
	rm -rf /var/lib/apt/lists/*



ARG nvmVersion=0.35.2
COPY --from=sweetchuck/nvm:${nvmVersion} /root/.nvm/       /root/.nvm/
COPY --from=sweetchuck/nvm:${nvmVersion} /root/.bashrc_nvm /root/.bashrc_nvm
RUN echo 'test -s "${HOME}/.bashrc_nvm" && . "${HOME}/.bashrc_nvm" || true' >> ~/.bashrc


# @todo https://github.com/moby/moby/issues/34482
ARG nodeVersion=13.6.0
COPY --from=sweetchuck/node:${nodeVersion} /root/.nvm/versions/node/v${nodeVersion}/ /root/.nvm/versions/node/v${nodeVersion}/
RUN . ${HOME}/.bashrc_nvm && nvm use --default ${nodeVersion}


ARG composerVersion=1.9.1
RUN expectedSignature=$(curl --disable https://composer.github.io/installer.sig) \
	&& \
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& \
	actualSignature=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") \
	&& \
	test "${expectedSignature}" == "${actualSignature}" \
	&& \
	php composer-setup.php \
		--quiet \
		--version		"${composerVersion}" \
		--install-dir	'/usr/local/bin' \
		--filename		'composer' \
	&& \
	rm composer-setup.php

RUN mkdir -p /etc/supervisor/conf.d
COPY assets/etc/supervisor/conf.d/10.program.chromium.ini /etc/supervisor/conf.d/10.program.chromium.ini

LABEL com.sweetchuck.nvm.version="${nvmVersion}"
LABEL com.sweetchuck.node.version="${nodeVersion}"
LABEL com.sweetchuck.composer.version="${composerVersion}"
LABEL com.sweetchuck.chromium.version="$(chromium-browser --version | sed --expression 's/Chromium //g')"
