ARG vendor=sweetchuck
ARG phpbrewVersion=1.23.1
FROM ${vendor}/phpbrew:${phpbrewVersion}

ARG phpName=70308
ARG phpVersion=7.3.8
ARG phpVersionMajorMinor=703

RUN phpbrew install \
		--mirror='https://www.php.net' \
		--jobs "$(nproc)" \
		--name "${phpName}-nts" \
		"${phpVersion}" \
		"+common${phpVersionMajorMinor}"

RUN phpbrew switch "${phpName}-nts"
RUN phpbrew extension install "+common${phpVersionMajorMinor}"
RUN phpbrew extension install opcache

RUN mkdir -p ~/php/sessions/${phpName}-nts.default

RUN rm -rf \
	"${HOME}/.phpbrew/php/${phpName}-nts/etc/" \
	"${HOME}/.phpbrew/php/${phpName}-nts/var/db/"

RUN fileNames=$(find "${HOME}/.phpbrew/template/${phpVersionMajorMinor}-nts/" -type 'f' -printf "%P\n"); \
	for fileName in $fileNames; do \
		mkdir -p $(dirname "${HOME}/.phpbrew/php/${phpName}-nts/${fileName}"); \
		sed \
			--expression="s/%PHP_VERSION_NAME%/${phpName}-nts/g" \
			--expression="s@%ENV_HOME%@${HOME}@g" \
			"${HOME}/.phpbrew/template/${phpVersionMajorMinor}-nts/${fileName}" \
			> "${HOME}/.phpbrew/php/${phpName}-nts/${fileName}"; \
	done

LABEL com.sweetchuck.php.version="${phpVersion}"
