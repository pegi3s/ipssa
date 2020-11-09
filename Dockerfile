FROM pegi3s/docker

LABEL maintainer="hlfernandez"

ADD image-files/compi.tar.gz /

RUN apt-get update && apt-get install bc

COPY resources/scripts/* /opt/scripts/

RUN chmod u+x /opt/scripts/*

COPY resources/ipssa-project.params /resources/ipssa-project.params

ADD pipeline.xml /pipeline.xml

ENTRYPOINT ["/compi", "run",  "-p", "/pipeline.xml"]


