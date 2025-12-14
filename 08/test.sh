#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 08/Day08-1.ex "${DATA_DIR}/08/sample") <(echo 5)
diff <(elixir 08/Day08-1.ex "${DATA_DIR}/08/input") <(echo 1087)

diff <(elixir 08/Day08-2.ex "${DATA_DIR}/08/sample") <(echo 8)
diff <(elixir 08/Day08-2.ex "${DATA_DIR}/08/input") <(echo 780)
