#!/bin/bash

set -e

DATA_DIR="./data/2020"

elixir 05/Day05-1.ex <(echo FBFBBFFRLR) | diff <(echo 357) -
diff <(elixir 05/Day05-1.ex "${DATA_DIR}/05/sample") <(echo 820)
diff <(elixir 05/Day05-1.ex "${DATA_DIR}/05/input") <(echo 906)

diff <(elixir 05/Day05-2.ex "${DATA_DIR}/05/input") <(echo 519)
