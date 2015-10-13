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

# set locale to utf8, or Ruby script will fail later on
RUN locale-gen en_US.utf8
#RUN localectl set-locale LANG=en_US.UTF-8  LANGUAGE=en_US.utf8 LC_ALL=en_US.utf8
RUN echo LANG "en_US.UTF-8" >> /etc/locale.conf
RUN echo LANGUAGE "en_US.UTF-8" >> /etc/locale.conf
RUN echo LC_ALL "en_US.UTF-8" >> /etc/locale.conf

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

WORKDIR /tmp
RUN wget --quiet https://github.com/jgm/pandoc/releases/download/1.15.0.6/pandoc-1.15.0.6-1-amd64.deb
RUN dpkg -i pandoc-1.15.0.6-1-amd64.deb
#RUN rm pandoc-1.15.0.6-1-amd64.deb

# install beautiful Adobe Source Code Pro
RUN apt-get install fontconfig
RUN wget https://github.com/adobe-fonts/source-code-pro/archive/2.010R-ro/1.030R-it.tar.gz
RUN tar xzf 1.030R-it.tar.gz
RUN cp source-code-pro-2.010R-ro-1.030R-it/OTF/*.otf /usr/local/share/fonts/
RUN fc-cache -f -v


RUN echo "last update 20151013"
RUN git clone https://github.com/isocpp/CppCoreGuidelines.git
#RUN wget --quiet https://raw.githubusercontent.com/isocpp/CppCoreGuidelines/master/CppCoreGuidelines.md

ADD pdf-template.tex /tmp/
RUN apt-get install fonts-arkpandora
RUN sed 's/Verdana/Veranda/g' -i ../pdf-template.tex
RUN sed 's/Consolas/Source Code Pro/g'  -i ../pdf-template.tex


VOLUME ["/tmp"]

WORKDIR /tmp/CppCoreGuidelines
ADD convertMdBlockCodes.rb /tmp/CppCoreGuidelines
RUN ruby convertMdBlockCodes.rb
ENTRYPOINT ["pandoc", "--template=../pdf-template.tex", "CppCoreGuidelines-converted.md", "--indented-code-classes=cpp", "--latex-engine=xelatex",  "-o", "CppCoreGuidelines.pdf"]
#CMD ["/bin/sh"]

# docker build --file="ubuntu1510.pandoc.Dockerfile" --tag="ubuntu1510.pandoc" .
# docker run -v /tmp:/tmp ubuntu1510.pandoc /path/to/markdown/file.md
# docker cp CONTAINER_NAME:/tmp/CppCoreGuidelines/CppCoreGuidelines.pdf /local/path/CppCoreGuidelines.pdf

