FROM resin/rpi-raspbian:wheezy
SHELL ["/bin/bash", "-c"]

#ENV WOLFRAM_DEPS "libatlas3-base libpango1.0-0 libcairo2 libglib2.0-0 libffi5 libpixman-1-0 zlib1g libfontconfig1 libfreetype6 libpng12-0 libexpat1 libuuid1 libportaudio2 libharfbuzz0a       libxmu6 libxrender1 libgfortran3" 


## command line only :    
#ENV WOLFRAM_DEPS "libatlas3-base libgfortran3"
## for drawing graphs : 
ENV WOLFRAM_DEPS "libxdmcp6 libxcb1 libpng12-0 libexpat1 libasound2 libxt6 libx11-6 libxext6 libfreetype6 libfontconfig1 libxcursor1 libxfixes3 libxrandr2 libice6 libsm6  libxmu6 libxrender1 libatlas3-base libgfortran3" 

 
RUN echo "deb-src http://archive.raspbian.org/raspbian wheezy main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update --yes 
# RUN apt-get install --no-install-recommends --yes wget xauth x11-xserver-utils vim less apt-file xvfb && apt-file update

RUN apt-get install --no-install-recommends vim build-essential xvfb libdrm2 libtirpc-dev


COPY scripts_to_install/build_static_xserver /usr/local/bin/build_static_xserver

# RUN build_static_xserver

RUN apt-get download $WOLFRAM_DEPS



RUN echo debconf shared/accepted-wolfram-eula select true | debconf-set-selections

ENV DEB_FILE wolfram-engine.deb

COPY build/wolfram-engine.deb ./wolfram-engine.deb
COPY scripts_to_install/cat_deps /usr/local/bin/
COPY scripts_to_install/wolfram_wrapper /usr/local/bin/
COPY tests /opt/wolfram_tests

RUN dpkg --force-all -i  *.deb

		
#RUN apt-get update --yes && apt-get install wolfram-engine --yes && apt-get remove wolfram-engine --yes


WORKDIR /mnt

ENTRYPOINT ["/usr/local/bin/wolfram_wrapper"]