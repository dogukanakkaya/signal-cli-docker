FROM ubuntu:22.04

SHELL ["/bin/bash", "-c"] 

RUN apt-get update && apt-get install -y curl wget zip git make protobuf-compiler build-essential openjdk-17-jre

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup default nightly

ARG SIGNAL_CLI_VERSION="0.10.5"

RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz
RUN tar xf signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz -C /opt
RUN ln -sf /opt/signal-cli-"${SIGNAL_CLI_VERSION}"/bin/signal-cli /usr/local/bin/

RUN git clone https://github.com/signalapp/libsignal.git
RUN cd /libsignal/java/ && ./build_jni.sh desktop
RUN cd /libsignal/java/shared/resources && zip -u /opt/signal-cli-"${SIGNAL_CLI_VERSION}"/lib/libsignal-client-*.jar libsignal_jni.so

RUN rm -rf /signal-cli-"${SIGNAL_CLI_VERSION}"-Linux.tar.gz