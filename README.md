# An Example For a Docker Tool Image

This little project demonstrates how to create a Docker image that can easily be run as a command line utility, making a command inside the Docker image available to the host system.

As an example, we assume that the host system doesn't have a working sed(1) command (the Unix Stream Editor).

## Building The image

Simply run `docker build --tag sed:1.0 .` in this directory.

## Running The Docker sed Tool

The shell wrapper script [`sed`](./sed) will invoke the Docker image, using the current directory as the working directory.

If you'd like to use sed with files, keep in mind that the Docker container can only access files that are in the current directory or below, but not outside of that.

If you need to process files outside of the current directory, use redirection:

```
./sed -e 's/foo/bar/g' </some/directory/file.txt >/another/directory/file.txt
```
