FROM resin/rpi-raspbian:wheezy
SHELL ["/bin/bash", "-c"]

ENV WOLFRAM_DEPS "gcc-4.8-base libatlas3-base libgfortran3 libxmu6 libxrender1" 


RUN apt-get update --yes && apt-get install --yes wget
RUN apt-get install --yes \
	$WOLFRAM_DEPS


ENV WOLFRAM_DEPS_DIR /opt/wolfram-deps


RUN for package in $WOLFRAM_DEPS; do  while read -r file; do   [ -f $file ] && echo "copying $file" && mkdir -p $WOLFRAM_DEPS_DIR/`dirname $file` && cp $file $WOLFRAM_DEPS_DIR/$file ; done < <(dpkg -L $package); done

RUN tar cvzf /opt/wolfram-deps.tgz $WOLFRAM_DEPS_DIR



RUN echo debconf shared/accepted-wolfram-eula select true | debconf-set-selections

ENV DEB_FILE wolfram-engine_10.0.0+2014012903_armhf.deb

RUN wget http://archive.raspberrypi.org/debian/pool/main/w/wolfram-engine/wolfram-engine_10.0.0+2014012903_armhf.deb
#RUN wget http://archive.raspberrypi.org/debian/pool/main/w/wolfram-engine/$DEB_FILE

RUN dpkg --force-all -i  $DEB_FILE

		
#RUN apt-get update --yes && apt-get install wolfram-engine --yes && apt-get remove wolfram-engine --yes





WORKDIR /mnt

ENTRYPOINT ["/usr/bin/wolfram"]