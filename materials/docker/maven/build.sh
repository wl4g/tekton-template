#!/bin/bash
# Copyright (c) 2017 ~ 2025, the original authors individual Inc,
# All rights reserved. Contact us James Wong <jameswong1376@gmail.com>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e

BASE_DIR="$(cd `dirname $0`; pwd)" && cd $BASE_DIR
MATERIAL_FILE="$BASE_DIR/apache-maven-3.8.6.tar.gz"

# Validate checksum for material.
VALIDATOR="$(ls *.sum|sed 's/.sum/sum/g')"
SUM="$(eval $VALIDATOR $MATERIAL_FILE)"
if [ $SUM != "$(cat *.sum)" ]; then
    echo "Illegal checksum $SUM for $MATERIAL_FILE" && exit 1
fi

# Build image.
IMAGE_TAG_SUFFIX="$(ls *.Dockerfile|sed 's/.Dockerfile//g'|sed 's/-/:/g')"
DOCKERFILE="$BASE_DIR/$(ls *.Dockerfile)"

if [ ! -f "$MATERIAL_FILE" ]; then
    curl -L -o $MATERIAL_FILE 'https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz'
fi

ln -snf $DOCKERFILE $BASE_DIR/Dockerfile
docker build -t wl4g-k8s/tekton-material-${IMAGE_TAG_SUFFIX} .
rm -rf $BASE_DIR/Dockerfile