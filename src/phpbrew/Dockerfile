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
		re2c \
		php7.2-cli \
		libxml2 \
		libxml2-dev \
		openssl1.1 \
		libssl-dev \
		libzip-dev \
		libbz2-dev \
		libcurl4-openssl-dev \
		libjpeg-turbo8-dev \
		libpng-dev \
		libxpm-dev \
		libfreetype6 \
		libfreetype6-dev \
		libpq-dev \
		libxslt1-dev \
		autoconf \
		libedit-dev \
		imagemagick \
		libmagickwand-dev \
		libyaml-dev \
		libmemcached-dev \
		libmcrypt-dev \
		libsodium23 \
		libsodium-dev \
		libwebp6 \
		libwebp-dev \
		libsqlite3-dev \
		libonig-dev \
	&& \
	rm -rf /var/lib/apt/lists/* \
	&& \
	sed \
		--in-place \
		--regexp-extended \
		--expression='s/;date.timezone([ \t]*)=([ \t]*).*/date.timezone\1=\2UTC/' \
		--expression='s/default_socket_timeout([ \t]*)=([ \t]*)60/default_socket_timeout\1=\2180/g' \
		/etc/php/7.2/cli/php.ini

ARG phpbrewVersion=1.24.1
ARG phpbrewDestination=/usr/local/bin/phpbrew
RUN curl \
		--location \
		--output "${phpbrewDestination}" \
		"https://github.com/phpbrew/phpbrew/raw/${phpbrewVersion}/phpbrew" \
	&& \
	chmod +x "${phpbrewDestination}"

RUN phpbrew init
COPY assets/phpbrew.config.yaml /root/.phpbrew/config.yaml
COPY assets/template            /root/.phpbrew/template

RUN sed \
		--in-place \
		--expression='/If not running interactively/d' \
		--expression='/\[ -z "$PS1" \] && return/d' \
		~/.bashrc \
	&& \
	echo 'test -s ~/.phpbrew/bashrc && . ~/.phpbrew/bashrc || true' >> ~/.bashrc

RUN mkdir -p \
		/var/log/php/ \
		/root/php/sessions

LABEL com.sweetchuck.os.name="ubuntu"
LABEL com.sweetchuck.os.version="${ubuntuVersion}"
LABEL com.sweetchuck.phpbrew.version="${phpbrewVersion}"
