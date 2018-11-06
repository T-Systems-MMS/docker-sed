FROM alpine:3.8
MAINTAINER stefan.bethke@t-systems.com
LABEL vendor=T-Systems\ Multimedia\ Solutions\ GmbH

VOLUME /work
WORKDIR /work
ENTRYPOINT ["/bin/sed"]
