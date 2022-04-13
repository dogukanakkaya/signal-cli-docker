FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"] 

RUN apt-get update && apt-get install -y curl wget zip git make protobuf-compiler build-essential openjdk-17-jre

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup default nightly

ARG SIGNAL_CLI_VERSION="0.10.5"
ARG LIBSIGNAL_VERSION="0.15.0"
ARG QRENCODE_VERSION="4.1.1"

RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz
RUN tar xf signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz -C /opt
RUN ln -sf /opt/signal-cli-"${SIGNAL_CLI_VERSION}"/bin/signal-cli /usr/local/bin/

RUN wget https://github.com/signalapp/libsignal/archive/refs/tags/v"${LIBSIGNAL_VERSION}".tar.gz
RUN tar xf v"${LIBSIGNAL_VERSION}".tar.gz -C /opt
RUN cd /opt/libsignal-"${LIBSIGNAL_VERSION}"/java/ && ./build_jni.sh desktop
RUN cd /opt/libsignal-"${LIBSIGNAL_VERSION}"/java/shared/resources && zip -u /opt/signal-cli-"${SIGNAL_CLI_VERSION}"/lib/libsignal-client-*.jar libsignal_jni.so


# To link device via QR Code
RUN wget https://fukuchi.org/works/qrencode/qrencode-"${QRENCODE_VERSION}".tar.gz
RUN tar xf qrencode-"${QRENCODE_VERSION}".tar.gz -C /opt
RUN cd /opt/qrencode-"${QRENCODE_VERSION}" && ./configure && make && make install && ldconfig

RUN cd /

RUN rm -rf /signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz
RUN rm -rf /v"${LIBSIGNAL_VERSION}".tar.gz
RUN rm -rf /qrencode-"${QRENCODE_VERSION}".tar.gz