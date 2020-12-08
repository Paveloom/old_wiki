Section: [[Setting up the environment]]

This guide is explicitly for the second version of WSL. All the following actions should be performed inside a WSL environment until told otherwise.

First, make sure you have the [`ssh`](https://packages.ubuntu.com/focal/ssh) package installed.

Then visit the configuration file of your SSH server:

```bash
sudo nano /etc/ssh/sshd_config
```

There are two things you'll need to change here. First, the port the SSH server will use. That's because the default port used is `22`, which is the same the host system uses for its SSH. You can change it for something else, `2222`, for example. Create or alter the line with the following content:

```bash
Port 2222
```

Second, you'll need to enable authentication. For that, you may use passwords or keys. Enable the preferred way (or both) by creating or altering the lines with the following contents:

```bash
PasswordAuthentication yes
PubkeyAuthentication yes
```

Save the file and restart the SSH server:

```bash
sudo service ssh --full-restart
```

Now you should be able to SSH into your WSL environment from the host system. Note, though, that you'll need to use your local IP for that, and not `localhost` or `127.0.0.1`. To get it, you should run `ifconfig` inside a WSL environment you want to connect to and copy the IP address from the `inet` line in the `eth0` section. After that, running the following on the host system:

```bash
ssh user@ip -p 2222 
```

should give a prompt to your shell. Note that this IP will change after restarting the WSL environment.