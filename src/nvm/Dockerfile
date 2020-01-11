ARG ubuntuVersion=19.04
FROM ubuntu:${ubuntuVersion}

SHELL ["/bin/bash", "--login", "-c"]
WORKDIR /root/

ARG aptCacher='http://172.17.0.1:3142'
RUN test "${aptCacher}" == '' || echo "Acquire::http::Proxy \"${aptCacher}\";" >> /etc/apt/apt.conf.d/00-apt_cacher

RUN DEBIAN_FRONTEND='noninteractive' \
	apt-get update -y \
	&& \
	DEBIAN_FRONTEND='noninteractive' \
	apt-get install -y \
		curl \
		gcc \
	&& \
	rm -rf /var/lib/apt/lists/*

ARG nvmVersion=0.35.2
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${nvmVersion}/install.sh | bash

RUN sed \
		--in-place \
		--expression='/If not running interactively/d' \
		--expression='/\[ -z "$PS1" \] && return/d' \
		--expression='/^export NVM_DIR/d' \
		--expression='/ This loads nvm/d' \
		~/.bashrc \
	&& echo 'test -s ~/.bashrc_nvm && . ~/.bashrc_nvm || true' >> ~/.bashrc \
	&& touch ~/.bashrc_nvm \
	&& echo 'export NVM_DIR="${HOME}/.nvm"' >> ~/.bashrc_nvm \
	&& echo 'test -s "${NVM_DIR}/nvm.sh" && . "${NVM_DIR}/nvm.sh" || true' >> ~/.bashrc_nvm \
	&& echo 'test -s "${NVM_DIR}/bash_completion" && . "${NVM_DIR}/bash_completion" || true' >> ~/.bashrc_nvm

LABEL com.sweetchuck.nvm.version="${nvmVersion}"
