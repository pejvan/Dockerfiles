FROM base/archlinux
MAINTAINER Pejvan Beigui <pejvan.beigui@robosoft.com>

USER root

RUN echo "Updating pacman"
RUN pacman-key --refresh-keys
RUN yes | pacman -Syyu
RUN pacman-db-upgrade

RUN echo "installing Elixir and deps"
RUN yes | pacman -S elixir

# set locale to utf8, as recommended by exlixir
RUN locale-gen en_US.utf8 
#RUN localectl set-locale LANG=en_US.UTF-8  LANGUAGE=en_US.utf8 LC_ALL=en_US.utf8
RUN echo LANG "en_US.UTF-8" >> /etc/locale.conf
RUN echo LANGUAGE "en_US.UTF-8" >> /etc/locale.conf
RUN echo LC_ALL "en_US.UTF-8" >> /etc/locale.conf

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"  
ENV LC_ALL "en_US.UTF-8"
#RUN locale #debug: ensure we get the correct values during install to avoid warnings

#installing phoenix, based on the instructions in http://www.phoenixframework.org/docs/installation
RUN mix local.hex
RUN yes | mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.3/phoenix_new-1.0.3.ez

RUN yes | pacman -S git npm

CMD ["/bin/sh"]

#how to build and run 
#docker build --file="archlinux.phoenix.Dockerfile" --tag="archlinux.phoenix" .
#docker run -i -t archlinux.phoenix bash
