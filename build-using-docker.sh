#/bin/bash

REL=1

build_cmake() {
    CMAKE_VER=3.31.5
    CMAKE=cmake-$CMAKE_VER

    ARCH=$1
    BUILD_DIR=build-$ARCH

    if [ ! -f $CMAKE.tar.gz ]; then
        wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/$CMAKE.tar.gz
        tar xvf $CMAKE.tar.gz
    fi

    cmake -GNinja -B $BUILD_DIR -S $CMAKE -D BUILD_SHARED_LIBS=OFF \
        -D CMAKE_EXE_LINKER_FLAGS="-static" -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_USE_SYSTEM_CURL=ON
    cmake --build $BUILD_DIR
    cmake --build $BUILD_DIR --target package

    cp $BUILD_DIR/$CMAKE-*.sh .
}

docker_build() {
    ARCH=$1
    PLATFORM=$2
    CMD=$3

    docker container run --rm -it -v $(pwd)/build:/src --workdir /src \
        --user $(id -u):$(id -g) --platform=$PLATFORM \
        dilshodm/apline-builder-$ARCH:3_${REL} \
        bash -c "$(declare -f build_cmake); build_cmake $ARCH"
}

docker_build arm64 linux/arm64
docker_build amd64 linux/amd64
docker_build arm   linux/arm/v7
