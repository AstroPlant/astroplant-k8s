# Copyright 2020, SURFsara.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:18.04

LABEL maintainer "David Salek <david.salek@surfsara.nl>"

RUN set -x && \
    apt-get update && \
    apt-get install git curl libpq-dev build-essential capnproto -y && \
    head -n 256 /dev/urandom > ./token_signer.key && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    git clone https://github.com/AstroPlant/astroplant-api.git
RUN export PATH="$HOME/.cargo/bin:$PATH" && \
    cd astroplant-api && \
    cargo build --release

ENV DATABASE_URL=
ENV MQTT_HOST=mosquitto.default.svc.cluster.local
ENV MQTT_PORT=1883
ENV MQTT_USERNAME=
ENV MQTT_PASSWORD=
ENV RUST_BACKTRACE=1
ENV RUST_LOG=warn,astroplant_rs_api=debug

EXPOSE 8080 8081

CMD ["/astroplant-api/target/release/astroplant-rs-api"]
