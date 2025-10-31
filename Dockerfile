FROM rust:1.89-trixie AS build
ARG IMAGE_REVISION
ARG IMAGE_SOURCE
WORKDIR /wasmtime
RUN set -e; \
    git init; \
    git remote add origin $IMAGE_SOURCE.git; \
    git fetch --depth 1 origin $IMAGE_REVISION; \
    git checkout FETCH_HEAD; \
    git submodule update --init --recursive
RUN cargo build --release

FROM scratch as bin
COPY --from=build /wasmtime/target/release/wasmtime /
