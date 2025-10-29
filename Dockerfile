FROM --platform=linux/arm64 ubuntu:22.04

RUN apt-get update && apt-get install -y build-essential
RUN apt-get install -y g++
RUN apt-get install -y libwayland-dev
RUN apt-get install -y libegl1-mesa-dev
RUN apt-get install -y libgles2-mesa-dev

WORKDIR /build
COPY . /build

CMD ["bash"]
