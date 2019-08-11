ARG vendor=sweetchuck
ARG imageTagParent=703-12.x.x
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


# @todo https://github.com/moby/moby/issues/34482
COPY --from=sweetchuck/nvm:0.34.0 /root/.nvm/       /root/.nvm/
COPY --from=sweetchuck/nvm:0.34.0 /root/.bashrc_nvm /root/.bashrc_nvm
RUN echo 'test -s "${HOME}/.bashrc_nvm" && . "${HOME}/.bashrc_nvm" || true' >> ~/.bashrc


# @todo https://github.com/moby/moby/issues/34482
COPY --from=sweetchuck/node:12.8.0 /root/.nvm/versions/node/v12.8.0/ /root/.nvm/versions/node/v12.8.0/
RUN . ${HOME}/.bashrc_nvm && nvm use --default 12.8.0


ARG composerVersion=1.9.0
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

LABEL com.sweetchuck.nvm.version="0.34.0"
LABEL com.sweetchuck.node.version="12.8.0"
LABEL com.sweetchuck.composer.version="${composerVersion}"
LABEL com.sweetchuck.chromium.version="$(chromium-browser --version | sed --expression 's/Chromium //g')"