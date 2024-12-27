#!/bin/bash

set -e

diff <(elixir 11/Day11.ex 11/sample) <(echo "37
26")
diff <(elixir 11/Day11.ex 11/input) <(echo "2243
2027")
