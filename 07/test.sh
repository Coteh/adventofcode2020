#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 07/Day07-1.ex "${DATA_DIR}/07/sample") <(echo 4)
diff <(elixir 07/Day07-1.ex "${DATA_DIR}/07/input") <(echo 372)

diff <(elixir 07/Day07-2.ex "${DATA_DIR}/07/sample") <(echo 32)
diff <(elixir 07/Day07-2.ex "${DATA_DIR}/07/sample2") <(echo 126)
diff <(elixir 07/Day07-2.ex "${DATA_DIR}/07/input") <(echo 8015)
