FROM ubuntu:18.04

# Install all of the prerequisites we need to build
RUN apt-get update \
 && apt-get install -y \
    clang \
    curl \
    libclang-dev \
    llvm-dev \
    musl-tools \
 && rm -rf /var/lib/apt/lists/*

# Set the path to find rustup and cargo now, before we even install it.
ENV PATH=$PATH:/root/.cargo/bin

# Allow the toolchain to use to be specified on the docker build command line
ARG toolchain

# Install rust
RUN [ -n "$toolchain" ] || (echo '`--build-arg toolchain=...` must be specified in the docker build command' >&2; exit 1) && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
    -y \
    --no-modify-path \
    --profile minimal \
    --default-toolchain $toolchain \
    --target x86_64-unknown-linux-musl

# And install cargo-make
RUN cargo install cargo-make
