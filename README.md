# userspice-db
Dockerized UserSpice

UserSpice (https://userspice.com/) is a php-based user management framework. While it's easy to install and manage, this is an attempt to wrap up the UserSpice files and supporting database into a MariaDB-based container.

1] To use it, edit the Dockerfile and check the environment variables, especially the time zone.
2] Build the image with  'docker build .'
3] Add the image to your web service's docker-compose.yml - the sample provided will create an empty web server. You'll want to link or otherwise map /opt/UserSpice so it's available to your web server.
4] Visit users/admin.php in the UserSpice path. The default credentials are 'admin' and 'password' so change them asap.
5] There's an empty usersc/ directory - leave it empty on the container and store custom files there; UserSpice will load them before its own.
6] Add the code below to any page needing access control:

require_once '../users/init.php';

require_once $abs_us_root.$us_url_root.'users/includes/header.php';

require_once $abs_us_root.$us_url_root.'users/includes/navigation.php';

if (!securePage($_SERVER['PHP_SELF'])){
die();
} 

Notes:
- The MariaDB server runs with a randomized root password. If you need to manage it directly, create an admin account with appropriate privileges before building the image.
- The build generates a random password for UserSpice to connect to the db. That password is stored in plaintext in users/init.php
