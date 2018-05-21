DOCKER_BUILDER_NAME=darvin/mathematica
WOLFRAM_DEB_FILE=wolfram-engine_10.0.0+2014012903_armhf.deb
WOLFRAM_URL_PATH=http://archive.raspberrypi.org/debian/pool/main/w/wolfram-engine/
WOLFRAM_DEB_FILE_RENAME=build/wolfram-engine.deb

.PHONY: builder install fetch-deps tests

all : builder install fetch-deps tests

builder :
	echo "building docker image..." 
	mkdir build || true
	if [ ! -f $(WOLFRAM_DEB_FILE_RENAME) ]; then \
		wget $(WOLFRAM_URL_PATH)/$(WOLFRAM_DEB_FILE) && \
		mv $(WOLFRAM_DEB_FILE) $(WOLFRAM_DEB_FILE_RENAME)  && \
        echo "dowloaded"; \
    fi
	docker build -t $(DOCKER_BUILDER_NAME)  -f Dockerfile.builder .	
	echo "building docker image finished!"

install :
	cp wolfram /usr/local/bin/

fetch-deps :
	docker run --rm --entrypoint /usr/local/bin/cat_deps $(DOCKER_BUILDER_NAME) > build/wolfram-deps-libs.tgz

tests :
	./wolfram -script tests/plot.m	
	./wolfram -script tests/plot_graphics.m

builder-sh :
	docker run --rm -it --entrypoint "bash" $(DOCKER_BUILDER_NAME)

