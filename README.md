# An Example For a Docker Tool Image

This little project demonstrates how to create a Docker image that can easily be run as a command line utility, making a command inside the Docker image available to the host system.

As an example, we assume that the host system doesn't have a working sed(1) command (the Unix Stream Editor).

## Building The Image

Simply run `docker build --tag sed:1.0 .` in this directory.

## Running The Docker sed Tool

Timply invoke the [`sed`](./sed) wrapper script, just as you would a regular `sed` binary.

```
./sed -i.bak -e 's/foo/bar/g' file.txt
```


## Running The Container With A Shell

Since the [Dockerfile](./Dockerfile) specifies an `ENTRYPOINT`, a regular `docker run` will always run `sed`. We can run some other command, for example a shell, by replacing the entrypoint when running the container:

```
docker run -it --rm -e USERID=$(id -u) --entrypoint=/bin/sh sed:1.0
```

## Dockerfile And Scripts

The image is built from the [Dockerfile](./Dockerfile).  It uses a minimal Linux base image (Alpine Linux), and installs `sudo`. It copies the `entrypoint.sh` script into the image. It declares `/work` as the working directory for the container. Finally, it declares the `entrypoint.sh` script as the entrypoint when running the container.

The [`entrypoint.sh`](./entrypoint.sh) script creates an entry in `/etc/passwd` for the host user and group ID, then executes the command and arguments passed from the `Dockerfile` and `docker` command invocation, respectively.

The [`sed`](./sed) wrapper script simply executes the `docker run` command with the appropriate parameters. In addition to the parameters needed by the tools, it passes the invoking users' ID.

Note that the wrapper script will invoke the Docker image using the current directory as the working directory. This means that the tool inside the container will have access to files in the current directory and below, but will not have access to other parts of the host's filesystem.  If you regularly need to access files in other places, you can add additional volume mounts to the wrapper script, to make those files available inside the container as well.


## File Ownership

When running Docker for Desktop (on macOS or Windows), volume mounts from the host into the container are implemented through a network file system, since the processes in the container run in a separate Linux VM, and the host file system is only accessible through the hypervisor. The host file system will always be accessed with the credentials of the user running the `docker` command. Any file or directory that processes in the container create on one of these mounted volumes will therefore be owned by the user running the `docker` command.

When running Docker on Linux, the container is part of the same operating system instance, and processes have direct (but restricted) access to the host's filesystems. When running processes inside the container, all new files on shared volumes will be owned by the user that process is running under. By default, that is the root user.

With this example tool, sed would create files as root, which would make working with them a lot harder.

To overcome this potential stumbling block, the entrypoint script uses `sudo` to change to the user ID of the user invoking `docker` (with he help of the wrapper script, which supplies the user and group id).
