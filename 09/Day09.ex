defmodule XMASSolution do
    def find_first_weak_number(xmas, preamble_length) do
        length = length(xmas)
        result = Stream.unfold(%{
            found: false,
            index: preamble_length,
            end: false
        }, fn acc ->
            if acc.end do
                nil
            else
                if acc.found or acc.index == length do
                    {acc, %{
                        found: acc.found,
                        index: acc.index,
                        end: true
                    }}
                else
                    val = xmas
                    |> Enum.at(acc.index)
                    # |> IO.inspect
                    prev_elems = xmas
                    |> Enum.slice(acc.index - preamble_length..acc.index - 1)
                    |> Enum.with_index
                    # |> IO.inspect
                    if prev_elems
                    |> Enum.all?(fn {prev_val, index} ->
                        result = prev_elems
                        |> Enum.filter(fn {prev_val2, index2} -> 
                            index != index2 and val - prev_val == prev_val2
                        end)
                        |> Enum.any?
                        !result
                    end) do
                        {acc, %{
                            found: true,
                            index: acc.index,
                            end: false
                        }}
                    else
                        {acc, %{
                            found: false,
                            index: acc.index + 1,
                            end: false
                        }}
                    end
                end
            end
        end)
        |> Enum.to_list
        |> List.last
        if result.found do
            xmas
            |> Enum.at(result.index)
        else
            nil
        end
    end
    def find_weakness(xmas, preamble_length) do
        num = find_first_weak_number(xmas, preamble_length)
        result = Stream.unfold(%{
            low: 0,
            high: 0,
            done: false
        }, fn acc ->
            if acc.done do
                nil
            else
                if acc.low == acc.high do
                    {acc, %{
                        low: acc.low,
                        high: acc.high + 1,
                        done: false
                    }}
                else
                    sum = xmas
                    |> Enum.slice(acc.low..acc.high)
                    |> Enum.sum
                    # |> IO.inspect
                    cond do
                        sum < num -> {acc, %{
                            low: acc.low,
                            high: acc.high + 1,
                            done: false
                        }}
                        sum > num -> {acc, %{
                            low: acc.low + 1,
                            high: acc.high,
                            done: false
                        }}
                        true -> {acc, %{
                            low: acc.low,
                            high: acc.high,
                            done: true
                        }}
                    end
                end
            end
        end)
        |> Enum.to_list
        |> List.last
        vals = xmas
        |> Enum.slice(result.low..result.high)
        |> Enum.sort
        low_val = vals
        |> List.first
        high_val = vals
        |> List.last
        low_val + high_val
    end
end

defmodule XMASParser do
    def parse_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&String.to_integer/1)
    end
end

if (length(System.argv) == 0) do
    IO.puts(:stderr, "Please provide a filename")
    System.halt(1)
end

[filename | rest] = System.argv
# NOTE pass 5 as preamble for test file otherwise you will get ArithmeticError
preamble = if length(rest) > 0 do
    rest
    |> List.first
    |> Integer.parse
    |> elem(0)
else
    25
end
# |> IO.inspect
xmas = XMASParser.parse_file(filename)
# |> IO.inspect
# Part 1
xmas
|> XMASSolution.find_first_weak_number(preamble)
|> IO.inspect
# Part 2
xmas
|> XMASSolution.find_weakness(preamble)
|> IO.inspect
