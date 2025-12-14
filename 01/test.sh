#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 01/Day01-1.ex "${DATA_DIR}/01/sample") <(echo 514579)
diff <(elixir 01/Day01-1.ex "${DATA_DIR}/01/input") <(echo 444019)

diff <(elixir 01/Day01-2.ex "${DATA_DIR}/01/sample") <(echo 241861950)
diff <(elixir 01/Day01-2.ex "${DATA_DIR}/01/input") <(echo 29212176)
