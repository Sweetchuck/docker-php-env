ARG vendor=sweetchuck
ARG phpVersion=7.3.8
FROM ${vendor}/php:${phpVersion}

RUN DEBIAN_FRONTEND='noninteractive' \
	apt-get update -y \
	&& \
	DEBIAN_FRONTEND='noninteractive' \
	apt-get install -y \
		git \
		mariadb-client \
		nginx \
		rsync \
		supervisor \
		unzip \
		zip \
	&& \
	rm -rf /var/lib/apt/lists/* \
	&& \
	service nginx stop \
	&& \
	mkdir -p \
		/var/log/nginx \
		/tmp/nginx/client_body \
		/tmp/nginx/fastcgi \
		/tmp/nginx/proxy \
		/tmp/nginx/scgi \
		/tmp/nginx/uwsgi \
	&& \
	rm -rf /etc/nginx/ \
	&& \
	service supervisor stop \
	&& \
	rm -rf /etc/supervisor/

COPY assets/etc/ /etc/

ARG phpName=70308
RUN sed \
		--in-place \
		--regexp-extended \
		--expression='s/autostart([ \t]*)=([ \t]*)false/autostart\1=\2true/g' \
		"${HOME}/.phpbrew/php/${phpName}-nts/etc/supervisor/10.program.php-fpm.prod.ini"

ENTRYPOINT ["supervisord"]
CMD ["--nodaemon", "--configuration", "/etc/supervisor/supervisor.ini"]
