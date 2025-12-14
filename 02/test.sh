#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 02/Day02-1.ex "${DATA_DIR}/02/sample") <(echo 2)
diff <(elixir 02/Day02-1.ex "${DATA_DIR}/02/input") <(echo 582)

diff <(elixir 02/Day02-2.ex "${DATA_DIR}/02/sample") <(echo 1)
diff <(elixir 02/Day02-2.ex "${DATA_DIR}/02/input") <(echo 729)
