defmodule Solution do
    def count_trees(lands, offset, stride \\ 1) do
        case length(lands) do
            0 -> 0
            _ -> length = length(Enum.at(lands, 0) |> String.graphemes)
                acc = Stream.iterate(0, &(rem(&1 + offset, length)))
                filtered_lands = Enum.map(Enum.filter(Enum.with_index(lands), fn {_, index} -> rem(index, stride) == 0 end), fn {land, _} -> land end)
                Enum.count(Enum.zip(acc, filtered_lands), fn {index, land} -> is_tree(land, index) end)
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
IO.puts(Integer.to_string(Solution.count_trees(lands, 1)
    * Solution.count_trees(lands, 3)
    * Solution.count_trees(lands, 5)
    * Solution.count_trees(lands, 7)
    * Solution.count_trees(lands, 1, 2)))
