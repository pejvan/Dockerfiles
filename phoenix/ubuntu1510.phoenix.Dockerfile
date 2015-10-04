FROM ubuntu:15.10
MAINTAINER Pejvan Beigui <pejvan.beigui@robosoft.com>

USER root
RUN echo "installing Erlang/OTP and Elixir"
WORKDIR /tmp

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y \
    curl \
    git

#installing Erlang first from https://www.erlang-solutions.com/downloads/download-erlang-otp
RUN curl -O https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    elixir \
    npm \
    inotify-tools

# set locale to utf8, as recommended by exlixir
RUN locale-gen en_US.utf8 
RUN update-locale LANG=en_US.utf8 LC_ALL=en_US.utf8
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"  
ENV LC_ALL "en_US.UTF-8"
#RUN locale #debug: ensure we get the correct values during install to avoid warnings

#installing phoenix, based on the instructions in http://www.phoenixframework.org/docs/installation
RUN mix local.hex
RUN mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.3/phoenix_new-1.0.3.ez

CMD ["/bin/sh"]

#how to build and run 
#docker build --file="ubuntu1510.phoenix.Dockerfile" --tag="ubuntu1510.phoenix" .
#docker run -i -t ubuntu1510.phoenix bash
