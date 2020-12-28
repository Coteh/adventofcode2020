defmodule Solution do
    def count_trees(lands) do
        case length(lands) do
            0 -> 0
            _ -> length = length(Enum.at(lands, 0) |> String.graphemes)
                acc = Stream.iterate(0, &(rem(&1 + 3, length)))
                Enum.count(Enum.zip(acc, lands), fn {index, land} -> is_tree(land, index) end)
        end
    end
    def is_tree(land, index) do
        Enum.at(land |> String.graphemes, index) == "#"
    end
end

defmodule LandLoader do
    def process_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1)
    end
end

[filename | _] = System.argv
lands = LandLoader.process_file(filename)
# IO.inspect(lands)
IO.inspect(Solution.count_trees(lands))
