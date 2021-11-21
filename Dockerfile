FROM php:7.4-apache

ADD /php/www /var/www/html

ADD ./files /files_aux

ADD /ibm_data_server_driver_package_linuxx64_v11.5.tar.gz /opt/ibm/

RUN	cd /usr/local/etc/php/ && \
	cp php.ini-development php.ini && \      
	export IBM_DB_HOME=/opt/ibm/dsdriver && \
       apt-get update && apt-get -y install ksh zip && \
       ksh /opt/ibm/dsdriver/installDSDriver && \
       env IBM_DB_HOME=/opt/ibm/dsdriver && \
       pecl install ibm_db2 && \
       echo "extension=ibm_db2.so" > /usr/local/etc/php/conf.d/ibm_db2.ini && \
       apt-get install nano && \       
       apt-get install -y libaio1  && \
       apt-get install -y alien && \
       alien -i /files_aux/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm  && \
       alien -i /files_aux/oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm  && \
       alien -i /files_aux/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm  && \
       echo "/usr/lib/oracle/11.2/client64/lib" > /etc/ld.so.conf.d/oracle.conf  && \
       ldconfig  && \
       export ORACLE_HOME=/usr/lib/oracle/11.2/client64/   && \
       cd /files_aux/php-src-PHP-7.4.3/ext/oci8/  && \
       phpize  && \
       ./configure --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
       make install  && \
       echo "extension=oci8.so" >  /usr/local/etc/php/conf.d/oci8.ini && \  
       cd /files_aux/php-src-PHP-7.4.3/ext/pdo_oci/  && \
       phpize  && \
       ./configure --with-pdo-oci=instantclient,/usr/lib/oracle/11.2/client64/lib  && \
       make install  && \
       echo "extension=pdo_oci.so" > /usr/local/etc/php/conf.d/pdo_oci.ini  && \
       pecl install xdebug-3.0.2 && docker-php-ext-enable xdebug && \
       cp /files_aux/xdebug/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini && \
       echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so" >> /usr/local/etc/php/php.ini
     