#!/bin/bash

if [[ "$target_platform" == linux* ]]; then
  # set
  # pwd
  # ls -R .
  # cp ${RECIPE_DIR}/CMakeLists.txt launcher/CMakeLists.txt
  pushd launcher
  # conda info
  # conda list
  # conda env list
  # "${PYTHON}" --version
  # default python is from the activate conda environment which is not the build environment; specify python to cmake
  cmake CMakeLists.txt -DPython3_EXECUTABLE="$PYTHON"
  cmake --build . --config Release
  # ls -R .
  # readelf -d build/NionUILauncher
  # readelf -dr build/NionUILauncher | grep QAbstractItem
  mkdir -p linux
  mv build linux/x64
  popd
  "${PYTHON}" -m pip install --no-deps --ignore-installed .
fi

if [[ "$target_platform" == osx* ]]; then
  pushd launcher
  # Ensure the tools are run using the host Qt, not the target Qt.
  export QT_HOST_PATH="$BUILD_PREFIX"
  # see https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
  # default python is from the activate conda environment which is not the build environment; specify python to cmake
  cmake ${CMAKE_ARGS} CMakeLists.txt -DPython3_EXECUTABLE="$PYTHON" -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
  cmake --build . --config Release
  mkdir -p build/Release
  mv build/*.app build/Release
  popd
  "${PYTHON}" -m pip install --no-deps --ignore-installed .
fi
