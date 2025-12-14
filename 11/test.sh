#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 11/Day11.ex "${DATA_DIR}/11/sample") <(echo "37
26")
diff <(elixir 11/Day11.ex "${DATA_DIR}/11/input") <(echo "2243
2027")
