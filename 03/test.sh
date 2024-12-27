#!/bin/bash

set -e

diff <(elixir 03/Day03-1.ex 03/sample) <(echo 7)
diff <(elixir 03/Day03-1.ex 03/input) <(echo 169)

diff <(elixir 03/Day03-2.ex 03/sample) <(echo 336)
diff <(elixir 03/Day03-2.ex 03/input) <(echo 7560370818)
