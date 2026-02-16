#!/bin/bash
# @todo: check why nice view fail to show anything in local build and fix
docker run --rm -it \
    -v $(pwd):/workspace \
    -w /workspace \
    zmkfirmware/zmk-build-arm:stable \
    bash -c '
        cd /workspace

        west init -l config
        west update
        west zephyr-export

        cd zmk/app

        west build -p -b nice_nano -- \
            -DSHIELD="corne_left nice_view_adapter nice_view" \
            -DZMK_CONFIG="/workspace/config"

        mkdir -p /workspace/artifacts
        cp build/zephyr/zmk.uf2 /workspace/artifacts/left.uf2

        west build -p -b nice_nano -- \
            -DSHIELD="corne_right nice_view_adapter nice_view" \
            -DZMK_CONFIG="/workspace/config"

        cp build/zephyr/zmk.uf2 /workspace/artifacts/right.uf2

        echo "Build complete!"
        ls -lh /workspace/artifacts/
    '
