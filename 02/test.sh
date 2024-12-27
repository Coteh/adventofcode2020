#!/bin/bash

set -e

diff <(elixir 02/Day02-1.ex 02/sample) <(echo 2)
diff <(elixir 02/Day02-1.ex 02/input) <(echo 582)

diff <(elixir 02/Day02-2.ex 02/sample) <(echo 1)
diff <(elixir 02/Day02-2.ex 02/input) <(echo 729)
