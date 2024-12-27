#!/bin/bash

set -e

diff <(elixir 04/Day04-1.ex 04/sample) <(echo 2)
diff <(elixir 04/Day04-1.ex 04/input) <(echo 192)

diff <(elixir 04/Day04-2.ex 04/sample) <(echo 2)
diff <(elixir 04/Day04-2.ex 04/valid_sample) <(echo 4)
diff <(elixir 04/Day04-2.ex 04/invalid_sample) <(echo 0)
diff <(elixir 04/Day04-2.ex 04/input) <(echo 101)
