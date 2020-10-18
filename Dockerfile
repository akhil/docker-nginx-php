FROM ubuntu:20.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System dependencies
RUN set -eux; \
	\
	apt-get update; \
    apt-get -y upgrade; \
	apt-get install -y --no-install-recommends \
		git \
		librsvg2-bin \
		imagemagick \
		# Required for SyntaxHighlighting
		python3 \
        libicu66 \
        php7.4-fpm \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-opcache \
        php7.4-intl \
        php7.4-gd \
        php7.4-bz2 \
        php7.4-zip \
        php7.4-xmlrpc \
        php7.4-curl \
        php7.4-mysql \
        php7.4-apcu \
        mcrypt \
        libvips-tools \
        ghostscript \
        xpdf-utils \
        poppler-utils \
        djvulibre-bin \
        pdf2djvu \
        netpbm \
        composer \
        curl \
        nginx \
	; 

RUN set -eux; \
        ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log \
        && rm -rf /var/lib/apt/lists/* \
    ;
#	rm -rf /var/lib/apt/lists/*

COPY nginx-php.conf /etc/nginx/sites-available/default

COPY mime.types /etc/nginx/

COPY index.php /var/www/html

RUN echo "exit 0" > /usr/sbin/policy-rc.d

CMD /etc/init.d/php7.4-fpm restart && nginx -g "daemon off;"
