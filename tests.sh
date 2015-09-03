#!/bin/bash
set -e

result=$(echo '{"foo": 2}' | docker run -i ${NAME}:${VERSION} '.foo')  && [[ "$result" == 2 ]]
