#!/bin/bash

set -e

diff <(elixir 10/Day10.ex 10/sample) <(echo "35
8")
diff <(elixir 10/Day10.ex 10/sample2) <(echo "220
19208")
diff <(elixir 10/Day10.ex 10/input) <(echo "2312
12089663946752")
