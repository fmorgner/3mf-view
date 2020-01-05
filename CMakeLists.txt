cmake_minimum_required(VERSION "3.12.0")

project("3mf-view"
  LANGUAGES CXX
  VERSION "0.0.1"
  DESCRIPTION "A simple 3mf file viewer"
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/Modules")

set(CMAKE_CXX_STANDARD "20")
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "RelWithDebInfo")
endif()

### Conan Dependencies Setup

include("Conan")

conan_check(REQUIRED)
conan_add_remote(NAME "fmorgner-public" URL "https://api.bintray.com/conan/fmorgner/conan-public")
conan_cmake_run(CONANFILE "conanfile.txt"
  BASIC_SETUP
  CMAKE_TARGETS
  BUILD "missing"
  NO_OUTPUT_DIRS
)

### System Dependencies Setup

find_package("Threads")
find_package("PkgConfig" REQUIRED)
pkg_check_modules("GTKmm3"
  REQUIRED
  IMPORTED_TARGET
  GLOBAL
  "gtkmm-3.0"
)

### Main Executable

add_executable("${PROJECT_NAME}"
  "src/main.cpp"
)

target_link_libraries("${PROJECT_NAME}"
  "CONAN_PKG::newtype"
  "Threads::Threads"
  "PkgConfig::GTKmm3"
)