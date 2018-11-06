#!/bin/sh

exec docker run -it --rm -v ${PWD}:/work sed:1.0 $@
