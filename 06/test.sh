#!/bin/bash

set -e

diff <(elixir 06/Day06-1.ex 06/sample) <(echo 11)
diff <(elixir 06/Day06-1.ex 06/input) <(echo 7110)

diff <(elixir 06/Day06-2.ex 06/sample) <(echo 6)
diff <(elixir 06/Day06-2.ex 06/input) <(echo 3628)
