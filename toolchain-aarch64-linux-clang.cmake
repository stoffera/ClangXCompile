
# For cross-compiling on arm64 Linux using gcc-aarch64-linux-gnu package:
# - install AArch64 tool chain:
#   $ sudo apt-get install g++-aarch64-linux-gnu
# - cross-compiling config
#   $ cmake -DCMAKE_TOOLCHAIN_FILE=../dynamorio/make/toolchain-arm64.cmake ../dynamorio
# You may have to set CMAKE_FIND_ROOT_PATH to point to the target enviroment, e.g.
# by passing -DCMAKE_FIND_ROOT_PATH=/usr/aarch64-linux-gnu on Debian-like systems.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TARGET_ABI "linux-gnu")
set(CROSS ${CMAKE_SYSTEM_PROCESSOR}-${TARGET_ABI}-)

# specify the cross compiler
# SET(CMAKE_C_COMPILER   ${CROSS}gcc)
# SET(CMAKE_CXX_COMPILER ${CROSS}g++)

find_program(CLANG_FULL_PATH clang 
  HINTS /opt/homebrew/opt/llvm/bin
  NO_DEFAULT_PATH
  REQUIRED)
get_filename_component(CLANG_DIR ${CLANG_FULL_PATH} PATH)
SET(CMAKE_C_COMPILER ${CLANG_DIR}/clang)
SET(CMAKE_CXX_COMPILER ${CLANG_DIR}/clang++)

SET(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/../aarch64-linux-gnu)
SET(CMAKE_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/../aarch64-linux-gnu)

SET(CMAKE_C_FLAGS 
  "--target=aarch64-linux-gnu --sysroot=${CMAKE_FIND_ROOT_PATH} -fuse-ld=lld --verbose")
SET(CMAKE_CXX_FLAGS 
  "--target=aarch64-linux-gnu --sysroot=${CMAKE_FIND_ROOT_PATH} -fuse-ld=lld -stdlib=libstdc++ --verbose")
  
# To build the tests, we need to set where the target environment containing
# the required library is. On Debian-like systems, this is
# /usr/aarch64-linux-gnu.
# SET(CMAKE_FIND_ROOT_PATH "/usr/aarch64-${TARGET_ABI}")
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Set additional variables.
# If we don't set some of these, CMake will end up using the host version.
# We want the full path, however, so we can pass EXISTS and other checks in
# the our CMake code.


# get_filename_component(GCC_DIR ${GCC_FULL_PATH} PATH)
SET(CMAKE_LINKER       ${CLANG_DIR}/lld      CACHE FILEPATH "linker")
SET(CMAKE_ASM_COMPILER ${CLANG_DIR}/clang      CACHE FILEPATH "assembler")
SET(CMAKE_OBJCOPY      ${CLANG_DIR}/llvm-objcopy CACHE FILEPATH "objcopy")
SET(CMAKE_STRIP        ${CLANG_DIR}/llvm-strip   CACHE FILEPATH "strip")
SET(CMAKE_CPP          ${CLANG_DIR}/clang++     CACHE FILEPATH "cpp")

# Optionally reduce compiler sanity check when cross-compiling.
set(CMAKE_TRY_COMPILE_TARGET_TYPE         STATIC_LIBRARY)
