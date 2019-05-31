#!/bin/bash
#
# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Generates the android_includes/ directory with the headers that normally will
# be generated by cmake. Run this command whenever you update the include files.

LOCAL_PATH=$(realpath $(dirname "$0"))

cleanup() {
  rm -rf "${WORKDIR}"
}
trap cleanup INT TERM ERR EXIT

WORKDIR=$(mktemp -d libdivsufsort.XXXXXX)
INCLUDESDIR="${LOCAL_PATH}/android_include"

pushd "${WORKDIR}"
cmake "${LOCAL_PATH}" \
  -DBUILD_DIVSUFSORT64=1 \
  -DBUILD_EXAMPLES=0 \
  -DUSE_OPENMP=0 \
  -DWITH_LFS=1

mkdir -p "${INCLUDESDIR}"
echo "Copying headers:"
cp -v include/*.h "${INCLUDESDIR}/"
popd >/dev/null

cat <<EOF
=============================================================
Remember to run the following command to add the new headers:

  git add android_include/*

EOF