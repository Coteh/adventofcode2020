#!/bin/bash

set -e

diff <(elixir 09/Day09.ex 09/sample 5) <(echo "127
62")
diff <(elixir 09/Day09.ex 09/input) <(echo "731031916
93396727")
