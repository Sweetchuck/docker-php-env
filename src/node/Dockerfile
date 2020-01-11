ARG vendor=sweetchuck
ARG nvmVersion=0.35.2
FROM ${vendor}/nvm:${nvmVersion}

ARG nodeVersion=13.6.0
ARG yarnVersion=1.21.1
RUN export NVM_DIR="${HOME}/.nvm" \
	&& \
	. $HOME/.nvm/nvm.sh \
	&& \
	nvm install ${nodeVersion} \
	&& \
	npm install --global "yarn@${yarnVersion}"

LABEL com.sweetchuck.node.version="${nodeVersion}"
LABEL com.sweetchuck.yarn.version="${yarnVersion}"
