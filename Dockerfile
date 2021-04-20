FROM ubuntu:20.04

# Setup workdir
RUN mkdir /osticket
WORKDIR /osticket

# Environment
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /osticket

# Install required packages
RUN apt-get update -yqq \
  && apt-get install -yqq \
  git \
  supervisor \
  nginx \
  php7.4-fpm \
  php7.4-imap \
  php7.4-gd \
  php7.4-gd \
  php7.4-apcu \
  php7.4-intl \
  php7.4-mbstring \
  php7.4-xml \
  php7.4-mysql \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt-get clean -yqq


# Clone osTicket
RUN git clone https://github.com/osTicket/osTicket .
RUN cp /osticket/include/ost-sampleconfig.php /osticket/include/ost-config.php
RUN chown www-data:www-data -R /osticket/

# # php-fpm config
# RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
# RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
# RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
# RUN php5enmod imap

# Copy nginx config and supervisord config
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord"]