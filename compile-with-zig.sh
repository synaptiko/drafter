#!/usr/bin/env bash

## Notes:
## - you need to run `git submodule update --init --recursive` after cloning this repo
## - only linux x86_64 is currently supported (for both compilation and result binary) and `zig` binary is added to this repo
## - zig 0.7.0 is used
## - the drafter binary is statically build with musl (instead of libc); this is currently hard-coded in `zig-cc` and `zig-cxx` scripts
## - after you run this script, there will be some changed files, just ignore them

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f "$DIR/zig" ]; then
	tar -xzvf $DIR/zig.tar.gz > /dev/null
fi

export CC="$DIR/zig-cc"
export CMAKE_C_COMPILER=$CC
export CXX="$DIR/zig-cxx"
export CMAKE_CXX_COMPILER=$CXX

make clean
python2 configure
cmake -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX --build . --target drafter --config .
make drafter
strip ./packages/drafter/drafter
