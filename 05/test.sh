#!/bin/bash

set -e

elixir 05/Day05-1.ex <(echo FBFBBFFRLR) | diff <(echo 357) -
diff <(elixir 05/Day05-1.ex 05/sample) <(echo 820)
diff <(elixir 05/Day05-1.ex 05/input) <(echo 906)

diff <(elixir 05/Day05-2.ex 05/input) <(echo 519)
