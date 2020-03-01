# Unofficial phpMyAdmin Docker image

Run phpMyAdmin with Alpine, supervisor, nginx and PHP FPM.

All following examples will bring you phpMyAdmin on `http://localhost:8080`
where you can enjoy your happy MySQL administration.

## Credentials

phpMyAdmin does use MySQL server credential, please check the corresponding
server image for information how it is setup.

The official MySQL and MariaDB use following environment variables to define these:

* `MYSQL_ROOT_PASSWORD` - This variable is mandatory and specifies the password that will be set for the `root` superuser account.
* `MYSQL_USER`, `MYSQL_PASSWORD` - These variables are optional, used in conjunction to create a new user and to set that user's password.

## Docker hub tags

You can use following tags on Docker hub:

* `latest` - latest stable release
* `5.0.1` - 5.0.1 release

Architectures

* `amd64` - x86-x64 `amd64-version` or `amd64-latest`
* `arm64v8` - aarch64 `arm64v8-version` or `arm64v8-latest
* `arm32v7` - armhf `arm32v7-version` or `arm32v7-latest`

## Usage with linked server

First you need to run MySQL or MariaDB server in Docker, and this image need
link a running mysql instance container:

```
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 gustavo8000br/phpmyadmin
```

## Usage with external server

You can specify MySQL host in the `PMA_HOST` environment variable. You can also
use `PMA_PORT` to specify port of the server in case it's not the default one:

```
docker run --name phpmyadmin -d -e PMA_HOST=dbhost -p 8080:80 gustavo8000br/phpmyadmin
```

## Adding Custom Configuration

You can add your own custom config.inc.php settings (such as Configuration Storage setup) 
by creating a file named "config.user.inc.php" with the various user defined settings
in it, and then linking it into the container using:

```
-v /some/local/directory/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php
```
On the "docker run" line like this:
``` 
docker run --name phpmyadmin -d --link mysql_db_server:db -p 8080:80 -v /some/local/directory/config.user.inc.php:/etc/phpmyadmin/config.user.inc.php gustavo8000br/phpmyadmin
```

See the following links for config file information.
https://docs.phpmyadmin.net/en/latest/config.html#config
https://docs.phpmyadmin.net/en/latest/setup.html

## Usage behind reverse proxys

Set the variable ``PMA_ABSOLUTE_URI`` to the fully-qualified path (``https://pma.example.net/``) where the reverse proxy makes phpMyAdmin available.

## Environment variables summary

* ``PMA_ARBITRARY`` - when set to 1 connection to the arbitrary server will be allowed
* ``PMA_HOST`` - define address/host name of the MySQL server
* ``PMA_VERBOSE`` - define verbose name of the MySQL server
* ``PMA_PORT`` - define port of the MySQL server
* ``PMA_HOSTS`` - define comma separated list of address/host names of the MySQL servers
* ``PMA_VERBOSES`` - define comma separated list of verbose names of the MySQL servers
* ``PMA_PORTS`` -  define comma separated list of ports of the MySQL servers
* ``PMA_USER`` and ``PMA_PASSWORD`` - define username to use for config authentication method
* ``PMA_ABSOLUTE_URI`` - define user-facing URI

For more detailed documentation see https://docs.phpmyadmin.net/en/latest/setup.html#installing-using-docker

[hub]: https://hub.docker.com/r/gustavo8000br/phpmyadmin/

