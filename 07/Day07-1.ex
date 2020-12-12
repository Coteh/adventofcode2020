defmodule Solution do
    def calculate_holding_bag_count(bag, bag_tree) do
        Map.keys(bag_tree)
        |> Enum.filter(&(&1 != bag))
        |> Enum.map(&(find_bag(&1, bag, bag_tree)))
        |> Enum.filter(&(&1))
        |> Enum.count
    end
    def find_bag(bag, dep_bag, bag_tree) do
        bag_tree[bag]
        |> Enum.map(fn dep ->
            case dep.item do
                nil -> false
                ^dep_bag -> true
                other -> find_bag(other, dep_bag, bag_tree)
            end
        end)
        |> Enum.any?(&(&1))
    end
end

defmodule BagTreeParser do
    def parse_file(filename) do
        process_file(filename)
        |> Enum.map(fn line ->
            String.split(line, "contain")
            |> Enum.map(&(String.trim(&1, " ")))
        end)
        |> Enum.reduce(%{}, fn requirement, acc ->
            [bag | deps] = requirement
            Map.put(acc, bag |> String.trim(" bags"), List.first(deps) |> String.split(", ") |> Enum.map(fn dep ->
                qty = List.first(Enum.flat_map(Regex.scan(~r/^[0-9]+/, dep), &(&1)))
                %{
                    qty: (if qty != nil, do: Integer.parse(qty) |> elem(0), else: 0),
                    item: Enum.at(Enum.flat_map(Regex.scan(~r/^[0-9]+ ([a-z ]+) bag(s|)(.|)$/, dep), &(&1)), 1)
                }
            end))
        end)
    end
    defp process_file(filename) do
        File.read!(filename)
        |> String.split("\n")
        |> Enum.drop(-1)
    end
end

if (length(System.argv) == 0) do
    IO.puts(:stderr, "Please provide a filename")
    System.halt(1)
end

[filename | _] = System.argv
bag_tree = BagTreeParser.parse_file(filename)
# IO.inspect(bag_tree)
# IO.inspect(Solution.find_bag("light red", "shiny gold", bag_tree))
IO.inspect(Solution.calculate_holding_bag_count("shiny gold", bag_tree))
