# fsm-docker
Docker image and docker-compose config for [Factorio Server Manager](https://github.com/mroote/factorio-server-manager)

## Prerequisites
You need to have [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
and [Docker Compose](https://docs.docker.com/compose/install/) installed.

## Usage
* Clone this repository somewhere on your server (for example: `git clone https://github.com/ita-sammann/fsm-docker.git $HOME/fsm-docker`)
  and `cd` to this directory.
* Edit variable values in the `.env` file:
  * `ADMIN_USER` (default `admin`): Name of the default user created for FSM web interface.
  * `ADMIN_PASS` (default `factorio`): Default user password. \
    __Important:__ _For security reasons, please create a new user via the web interface and delete the default one._
  * `RCON_PASS` (default empty string): Password for Factorio RCON (FSM uses it to communicate with the Factorio server). \
    If left empty, a random password will be generated and saved on the first start of the server. You can see the password in `fsm-data/conf.json` file.
  * `COOKIE_ENCRYPTION_KEY` (default empty string): The key used to encrypt auth cookie for FSM web interface. \
    If left empty, a random key will be generated and saved on the first start of the server. You can see the key in `fsm-data/conf.json` file.
  * `UPDATE` (default true): If set to true, FSM will try to update Factorio server to the latest version when starting the container.
  * `DOMAIN_NAME` (must be set manually): The domain name where your FSM web interface will be available. Must be set,
    so [Let's Encrypt](https://letsencrypt.org/) service can issue a valid HTTPS certificate for this domain.
  * `EMAIL_ADDRESS` (must be set manually): Your email address. Used only by Let's Encrypt service.
* Run
```
docker-compose up -d
```

It may take some time for Let's Encrypt to issue the certificate, so for the first couple of minutes after starting the container you may see
"Your connection is not private" error when you open your Factorio Server Manager address in your browser. This error should disappear within
a couple of minutes, if configuration parameters are set correctly.

### Simple configuration without HTTPS
If you don't care about HTTPS and want to run just the Factorio Server Manager, you can use `docker-compose.simple.yaml`.

Ignore `DOMAIN_NAME` and `EMAIL_ADDREESS` variables in `.env` file and run
```
docker-compose -f docker-compose.simple.yaml up -d
```

## Update Factorio version
If you want to update Factorio to the latest version:
1. Save your game and stop Factorio server in FSM web interface.
2. Run `docker-compose restart` (or `docker-compose -f docker-compose.simple.yaml restart` if you are using simple configuration).

After container starts, latest Factorio version will be downloaded and installed.
