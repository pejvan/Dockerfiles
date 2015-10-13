FROM ubuntu:15.10
MAINTAINER Pejvan Beigui <pejvan.beigui@robosoft.com>

USER root
RUN echo "installing Pandoc"
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y \
    #pandoc \
    wget \
    # this is pandoc dependency
    libgmp10 \
    # pandoc requires xelatex for pdf output
    texlive-xetex

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git

RUN echo "line 17"

WORKDIR /tmp
RUN wget --quiet https://github.com/jgm/pandoc/releases/download/1.15.0.6/pandoc-1.15.0.6-1-amd64.deb
RUN dpkg -i pandoc-1.15.0.6-1-amd64.deb

RUN git clone https://github.com/isocpp/CppCoreGuidelines.git
#RUN wget --quiet https://raw.githubusercontent.com/isocpp/CppCoreGuidelines/master/CppCoreGuidelines.md

VOLUME ["/tmp"]

WORKDIR /tmp/CppCoreGuidelines
ENTRYPOINT ["pandoc", "CppCoreGuidelines.md", "--latex-engine=xelatex",  "-o", "CppCoreGuidelines.pdf"]
#ENTRYPOINT ["echo", "hello"]
#CMD ["/bin/sh"]

# docker build --file="ubuntu1510.pandoc.Dockerfile" --tag="ubuntu1510.pandoc" .
# docker run -v /tmp:/tmp ubuntu1510.pandoc /path/to/markdown/file.md
# docker cp CONTAINER_NAME:/tmp/CppCoreGuidelines/CppCoreGuidelines.pdf /local/path/CppCoreGuidelines.pdf

