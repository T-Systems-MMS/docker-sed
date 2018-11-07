FROM alpine:3.8
MAINTAINER stefan.bethke@t-systems.com
LABEL vendor=T-Systems\ Multimedia\ Solutions\ GmbH

# We need sudo to change to the appropriate host user ID
RUN apk add sudo

# The entrypoint script changes to the appropriate user
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

# The wrapper script will mount the host current directory here
VOLUME /work
WORKDIR /work

# Run the wrapper script. Docker will append any command line parameters
# passed to this array.
ENTRYPOINT ["/bin/entrypoint.sh", "/bin/sed"]
