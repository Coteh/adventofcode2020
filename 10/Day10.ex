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
        # Add 1 to number of 3 diffs to account for device's built-in adapter always being 3 higher than the highest adapter
        result.num_1_diff * (result.num_3_diff + 1)
    end
    def calculate_num_orderings(adapters) do
        sorted = adapters
        # Add the charging outlet (0 joltage rating) to the adapter list since
        # the lowest numbered adapter from the charging outlet doesn't necessarily have to be the first selected
        # (e.g. if input has 1, 2, and 3, 3 could be selected first since it can take the charging outlet as input and produce its rated output joltage)
        |> List.insert_at(0, 0)
        |> Enum.sort
        # |> IO.inspect

        result = %{
            curr_index: 0,
            visited: sorted
                |> Enum.zip(Stream.cycle([0]))
                |> Map.new
                |> Map.put(List.first(sorted), 1),
            done: false
        }
        |> Stream.unfold(fn acc ->
            if acc.done do
                nil
            else
                if acc.curr_index == length(sorted) do
                    {acc, %{
                        curr_index: acc.curr_index,
                        visited: acc.visited,
                        done: true
                    }}
                else
                    # acc
                    # |> IO.inspect
                    # Get the current number
                    curr = Enum.at(sorted, acc.curr_index)
                    # Take the visited value for current number (n)
                    curr_visited_count = acc.visited[curr]
                    # Find all numbers within 3 values of current number
                    diff_adapters = sorted
                        |> Enum.slice(acc.curr_index + 1, 3)
                        # |> IO.inspect
                        |> Enum.filter(&(&1 - curr <= 3))
                        # |> IO.inspect(charlists: :as_lists)
                    # For each number found, update the corresponding visited values (m) to be m + n
                    updated_visited = diff_adapters
                    |> Enum.reduce(acc.visited, fn adapter, acc_table ->
                        Map.put(acc_table, adapter, acc_table[adapter] + curr_visited_count)
                    end)
                    {acc, %{
                        curr_index: acc.curr_index + 1,
                        visited: updated_visited,
                        done: false
                    }}
                end
            end
        end)
        |> Enum.to_list
        |> List.last
        # |> IO.inspect
        result.visited[List.last(sorted)]
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
# Part 2
adapters
|> Solution.calculate_num_orderings
|> IO.inspect
