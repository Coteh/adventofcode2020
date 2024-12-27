defmodule Solution do    
    def calculate_expense(filename) do
        vals = process_file(filename)
        Enum.reduce(Enum.flat_map(vals, fn x -> Enum.filter(vals, fn y -> x + y == 2020 end) end), fn(x, acc) -> x * acc end)
    end
    defp process_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1) |> Enum.map(&String.to_integer/1)
    end
end

[filename | _] = System.argv
IO.inspect(Solution.calculate_expense(filename))
