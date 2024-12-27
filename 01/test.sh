#!/bin/bash

set -e

diff <(elixir 01/Day01-1.ex 01/sample) <(echo 514579)
diff <(elixir 01/Day01-1.ex 01/input) <(echo 444019)

diff <(elixir 01/Day01-2.ex 01/sample) <(echo 241861950)
diff <(elixir 01/Day01-2.ex 01/input) <(echo 29212176)
