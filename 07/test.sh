#!/bin/bash

set -e

diff <(elixir 07/Day07-1.ex 07/sample) <(echo 4)
diff <(elixir 07/Day07-1.ex 07/input) <(echo 372)

diff <(elixir 07/Day07-2.ex 07/sample) <(echo 32)
diff <(elixir 07/Day07-2.ex 07/sample2) <(echo 126)
diff <(elixir 07/Day07-2.ex 07/input) <(echo 8015)
