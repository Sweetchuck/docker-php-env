ARG vendor=sweetchuck
ARG nvmVersion=0.33.11
FROM ${vendor}/nvm:${nvmVersion}

ARG nodeVersion=11.15.0
ARG yarnVersion=1.16.0
RUN export NVM_DIR="${HOME}/.nvm" \
	&& \
	. $HOME/.nvm/nvm.sh \
	&& \
	nvm install ${nodeVersion} \
	&& \
	npm install --global "yarn@${yarnVersion}"

LABEL com.sweetchuck.node.version="${nodeVersion}"
LABEL com.sweetchuck.yarn.version="${yarnVersion}"
