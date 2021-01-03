defmodule Solution do
    def calculate_jolt_diff_value(adapters) do
        sorted = adapters
        |> Enum.sort
        # |> IO.inspect

        result = sorted
        |> List.insert_at(-1, List.last(sorted) + 3)
        # |> IO.inspect
        |> Enum.reduce(%{
            curr: 0,
            prev: nil,
            num_1_diff: 0,
            num_3_diff: 0
        }, fn x, acc ->
            diff = case acc.curr do
                nil -> 0
                c -> case acc.prev do
                    nil -> 0
                    p -> c - p
                end
            end
            # |> IO.inspect
            num_1_diff = case diff do
                1 -> acc.num_1_diff + 1
                _ -> acc.num_1_diff
            end
            num_3_diff = case diff do
                3 -> acc.num_3_diff + 1
                _ -> acc.num_3_diff
            end
            %{
                curr: x,
                prev: acc.curr,
                num_1_diff: num_1_diff,
                num_3_diff: num_3_diff
            }
        end)
        # Add 1 to 3 diff for device's built-in adapter always being 3 higher than the highest adapter
        result.num_1_diff * (result.num_3_diff + 1)
    end
end

defmodule JoltParser do
    def parse_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&String.to_integer/1)
    end
end

if (length(System.argv) == 0) do
    IO.puts(:stderr, "Please provide a filename")
    System.halt(1)
end

[filename | _] = System.argv
# |> IO.inspect
adapters = JoltParser.parse_file(filename)
# |> IO.inspect
# Part 1
adapters
|> Solution.calculate_jolt_diff_value
|> IO.inspect
# TODO Part 2
