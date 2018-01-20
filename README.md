### Wurm Unlimited Dedicated Linux Server Installer

For now, the README is going to be light on docs.

* Follow the first part of the guide found [here](http://derpycloud.com/creating-wurm-unlimited-dedicated-linux-server/) (right up to ` ensure the following ports are allowed:`)
* install git:
  * `apt-get -y install git`
* clone this repo:
  * `git clone https://github.com/jonsjava/wurm_unlimited_server.git`
* go into the directory and start the install:
  * `cd wurm_unlimited_server; && ./installer.sh`
* follow the prompts
* update `/home/steam/wu/server.cfg`
* run `sudo service wurm start`
