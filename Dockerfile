FROM resin/rpi-raspbian:wheezy
SHELL ["/bin/bash", "-c"]

ENV WOLFRAM_DEPS "libatlas3-base libpango1.0-0 libcairo2 libglib2.0-0 libffi5 libpixman-1-0 zlib1g libfontconfig1 libfreetype6 libpng12-0 libexpat1 libuuid1 libportaudio2 libharfbuzz0a" 

 


RUN apt-get update --yes && apt-get install --yes wget
RUN apt-get install --yes \
	$WOLFRAM_DEPS


ENV WOLFRAM_DEPS_DIR /opt/wolfram-deps


RUN for package in $WOLFRAM_DEPS; do  while read -r file; do   [ -f $file ] && echo "copying $file" && mkdir -p $WOLFRAM_DEPS_DIR/`dirname $file` && cp $file $WOLFRAM_DEPS_DIR/$file ; done < <(dpkg -L $package); done

RUN tar cvzf /opt/wolfram-deps.tgz $WOLFRAM_DEPS_DIR



RUN echo debconf shared/accepted-wolfram-eula select true | debconf-set-selections

ENV DEB_FILE wolfram-engine.deb

COPY build/wolfram-engine.deb ./wolfram-engine.deb

RUN dpkg --force-all -i  $DEB_FILE

		
#RUN apt-get update --yes && apt-get install wolfram-engine --yes && apt-get remove wolfram-engine --yes





WORKDIR /mnt

ENTRYPOINT ["/usr/bin/wolfram"]