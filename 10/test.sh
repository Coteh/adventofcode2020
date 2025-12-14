#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 10/Day10.ex "${DATA_DIR}/10/sample") <(echo "35
8")
diff <(elixir 10/Day10.ex "${DATA_DIR}/10/sample2") <(echo "220
19208")
diff <(elixir 10/Day10.ex "${DATA_DIR}/10/input") <(echo "2312
12089663946752")
