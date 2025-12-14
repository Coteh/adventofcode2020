#!/bin/bash

set -e

DATA_DIR="./data/2020"

diff <(elixir 09/Day09.ex "${DATA_DIR}/09/sample" 5) <(echo "127
62")
diff <(elixir 09/Day09.ex "${DATA_DIR}/09/input") <(echo "731031916
93396727")
