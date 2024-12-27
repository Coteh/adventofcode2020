#!/bin/bash

set -e

diff <(elixir 08/Day08-1.ex 08/sample) <(echo 5)
diff <(elixir 08/Day08-1.ex 08/input) <(echo 1087)

diff <(elixir 08/Day08-2.ex 08/sample) <(echo 8)
diff <(elixir 08/Day08-2.ex 08/input) <(echo 780)
