FROM alpine:3.9

LABEL vendor="PHPMyAdmin"
LABEL maintainer="Gustavo Mathias Rocha <gustavo8000@icloud.com>"

# set version label
ARG BUILD_DATE
ARG VERSION
ARG EXT_VERSION
LABEL build_version="gustavo8000br version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# Install dependencies
RUN apk add --no-cache \
    php7-session \
    php7-mysqli \
    php7-mbstring \
    php7-xml \
    php7-gd \
    php7-zlib \
    php7-bz2 \
    php7-zip \
    php7-openssl \
    php7-curl \
    php7-opcache \
    php7-json \
    nginx \
    php7-fpm \
    supervisor \
    zip \
    curl \
    jq

# Copy configuration
COPY etc /etc/

# Copy main script
COPY run.sh /run.sh
RUN chmod u+rwx /run.sh

# Download package and extract to web folder
RUN set -ex && echo "**** install phpmyadmin ****"; \
    if [ -z ${EXT_VERSION+x} ]; then \
        EXT_VERSION=$(curl -s https://api.github.com/repos/phpmyadmin/phpmyadmin/releases/latest | jq -r '. | .name'); \
    fi; \
    curl -o phpMyAdmin-${EXT_VERSION}-all-languages.zip -SL https://files.phpmyadmin.net/phpMyAdmin/${EXT_VERSION}/phpMyAdmin-${EXT_VERSION}-all-languages.zip > /dev/null; \
    unzip -q phpMyAdmin-${EXT_VERSION}-all-languages.zip; \
    mv phpMyAdmin-${EXT_VERSION}-all-languages /www; \
    rm -rf /www/setup/ /www/examples/ /www/test/ /www/po/ /www/composer.json /www/RELEASE-DATE-$VERSION; \
    sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /www/libraries/vendor_config.php; \
    mkdir /www/tmp; \
    chown -R root:nobody /www; \
    find /www -type d -exec chmod 750 {} \; &&\
    find /www -type f -exec chmod 640 {} \; &&\
    chmod 777 /www/tmp; \
    echo "**** clean up ****"; \
	rm phpMyAdmin-${EXT_VERSION}-all-languages.zip; \
    echo "**** Add directory for sessions to allow session persistence ****"; \
    mkdir /sessions;

# We expose phpMyAdmin on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["phpmyadmin"]
