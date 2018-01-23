### Wurm Unlimited Dedicated Linux Server Installer

#### SUPPORTED OPERATING SYSTEMS

* Ubuntu >= 16.04
* LinuxMint >= 17.1


#### EASY-INSTALLER METHOD
I've simplified the install greatly.
Before I get into how to use it, I need to mention the following:

----

**BY USING THIS YOU AGREE TO THE Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX**

My installer installs Oracle Java for you, and auto accepts the EULA.  By using my installer, you agree to the terms outlined [**AT THIS LINK**](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)

---
To install the server, simply run the following command on your Linux server (as root, or a user that can `sudo`:)

```bash
curl -s https://raw.githubusercontent.com/jonsjava/wurm_unlimited_server/master/download.sh|sudo bash
```

Follow the on-screen prompts and it should do the rest for you.

If it gives an error, run the command again (Usually Java takes too long to download).

If you wish to check the status of the service once install is complete:

```bash
sudo service wurm status
```

Once done checking the status, hit `q`

To stop/start/restart the service:

```bash
# stop:
sudo service wurm stop
# start:
sudo service wurm start
# restart:
sudo service wurm restart
```

#### EDITING THE CONFIGS

if at any point you need to change the config, you can either re-run the installer, or run the following (change `SERVER_USER` to the user you defined in the install. If you did not define one, that user will be `steam`):

```bash
sudo su - SERVER_USER
```
Once in as the user, run the following to edit the config:

```bash
nano wu/server.cfg
```
Once you have completed editing the file, exit out back into your user:

```bash
exit
```
Finally, restart the service:

```bash
sudo service wurm restart
```

#### UPDATING THE SERVER:

To update the server, ensure that ``/root/wurm_unlimited_server/server.cfg` has the correct values, then run:

```bash
sudo su - -c 'cd /root/wurm_unlimited_server/;./update_server.sh'
```

This will reconfigure the service with the values set in `/root/wurm_unlimited_server/server.cfg`, update the server files from Steam, and download the latest `server-modlauncher`

**WARNING** This *WILL* force the wurm server to stop during the upgrade. It will auto-restart once complete.

#### OLD METHOD

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
