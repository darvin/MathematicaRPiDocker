FROM resin/rpi-raspbian:wheezy

RUN apt-get update --yes && apt-get install --yes \
		wget \
		gcc-4.8-base libatlas3-base libgfortran3
#RUN apt-get update --yes && apt-get install wolfram-engine --yes && apt-get remove wolfram-engine --yes


RUN echo debconf shared/accepted-wolfram-eula select true | debconf-set-selections

ENV DEB_FILE wolfram-engine_10.0.0+2014012903_armhf.deb

RUN wget http://archive.raspberrypi.org/debian/pool/main/w/wolfram-engine/$DEB_FILE

RUN dpkg --force-all -i  $DEB_FILE

WORKDIR /mnt

ENTRYPOINT ["/usr/bin/wolfram"]