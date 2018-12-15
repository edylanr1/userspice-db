FROM mariadb:latest

LABEL description="UserSpice preconfigured database and files"
LABEL maintainer="Jon Tullett <jon.tullett@gmail.com>"
LABEL version="0.3"

ENV MYSQL_RANDOM_ROOT_PASSWORD=true
ENV MYSQL_DATABASE="userspice"
ENV USERSPICE_PASSWORD="$USERSPICE_PASSWORD"
ENV DATABASE_HOST="userspice"

# Don't forget to escape the slash if you set the timezone
ENV TIMEZONE="Africa\/Johannesburg"

# Clone UserSpice
RUN true \
    && mkdir -p /opt/UserSpice \
    && apt-get update > /dev/null \
    && apt-get install -y apt-utils git pwgen > /dev/null \
    && git clone https://github.com/mudmin/UserSpice4.git /opt/UserSpice

# Set up init.php. Not the stock init.php - it's truncated halfway through for the installer
COPY ./init.php /opt/UserSpice/users

RUN true \
    && export USERSPICE_PASSWORD=`pwgen 20 1` \
    && sed -i "1s/^/USE userspice;\n/" /opt/UserSpice/install/install/includes/sql.sql \
    && cp /opt/UserSpice/install/install/includes/sql.sql /docker-entrypoint-initdb.d/userspice.sql \
    && echo "CREATE USER 'userspice_admin'@'%' IDENTIFIED BY '${USERSPICE_PASSWORD}';" >> /docker-entrypoint-initdb.d/setup.sql \
    && echo "GRANT SELECT, INSERT, UPDATE, DELETE ON \`userspice\`.* TO 'userspice_admin'@'%';" >> /docker-entrypoint-initdb.d/setup.sql \
    && sed -i "s/HOSTNAME/${DATABASE_HOST}/" /opt/UserSpice/users/init.php \
    && sed -i "s/DATABASE/${MYSQL_DATABASE}/" /opt/UserSpice/users/init.php \
    && sed -i "s/PASSWORD/${USERSPICE_PASSWORD}/" /opt/UserSpice/users/init.php \
    && sed -i "s/TIMEZONE/${TIMEZONE}/" /opt/UserSpice/users/init.php \
    && apt-get remove -y git pwgen

# Standard MySQL port, and a default mount point
EXPOSE 3306
VOLUME /opt/UserSpice
