#!/bin/sh

# This wrapper script invokes docker, and supplies the user and group ID
# for the entrypoint script. On windows, it might be best to leave out the
# IDs.
exec docker run -i --rm \
  -e "USERID=$(id -u)" -e "GROUPID=$(id -g)" \
  -v "${PWD}:/work" sed:1.0 $@
