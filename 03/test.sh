#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 03/Day03-1.ex "${DATA_DIR}/03/sample") <(echo 7)
diff <(elixir 03/Day03-1.ex "${DATA_DIR}/03/input") <(echo 169)

diff <(elixir 03/Day03-2.ex "${DATA_DIR}/03/sample") <(echo 336)
diff <(elixir 03/Day03-2.ex "${DATA_DIR}/03/input") <(echo 7560370818)
