# userspice-db
Dockerized UserSpice

UserSpice (https://userspice.com/) is a php-based user management framework. While it's easy to install and manage, this is an attempt to wrap up the UserSpice files and supporting database into a MariaDB-based container.

The quickest start is to create a directory which uid 999* can write to, then run
> docker-compose up -d

That will: 
- spin up a container with a preconfigured UserSpice database
- copy the UserSpice files into the given directory (*MariaDB's default UID is 999)
- start a webserver listening on port 8080
- start a separate container with a php handler

Once it's up, browse to http://localhost:8080/UserSpice/users/admin.php to get started.

Add this code at the top of any php page needing access control:
```
require_once '../users/init.php';
require_once $abs_us_root.$us_url_root.'users/includes/header.php';
require_once $abs_us_root.$us_url_root.'users/includes/navigation.php';
if (!securePage($_SERVER['PHP_SELF'])){
    die();
} 
```

Notes:
- The MariaDB server runs with a randomized root password. If you need to manage it directly, create an admin account with appropriate privileges before building the image.
- The build generates a random password for UserSpice to connect to the db. That password is stored in plaintext in users/init.php
