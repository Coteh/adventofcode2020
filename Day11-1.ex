defmodule Solution do
    def calculate_seat_ordering_count(seats, lookup_type) do
        lookup_func = case lookup_type do
            :adjacent -> &get_adjacent_seats/4
            _ -> &get_visible_seats/4
        end
        tolerance = case lookup_type do
            :adjacent -> 4
            _ -> 5
        end
        result_arr = calculate_seat_orderings(seats, lookup_func, tolerance)
        0..(seats.rows * seats.cols - 1)
        |> Enum.count(&(:array.get(&1, result_arr) == :occupied))
    end
    def calculate_seat_orderings(seats, lookup_func, tolerance) do
        seats.grid
        |> Stream.unfold(fn acc ->
            prev_arr = acc
            curr_arr = 0..(seats.rows * seats.cols - 1)
            |> Enum.reduce(acc, fn index, acc ->
                curr = :array.get(index, acc)
                cond do
                    curr == :empty && adjacent_not_occupied?(index, prev_arr, seats.rows, seats.cols, lookup_func) -> :array.set(index, :occupied, acc)
                    curr == :occupied && adjacent_has_seat_count?(index, prev_arr, seats.rows, seats.cols, :occupied, tolerance, lookup_func) -> :array.set(index, :empty, acc)
                    true -> acc
                end
            end)
            # SeatPrinter.print_seats(curr_arr, seats.rows, seats.cols)
            # Check if this new arrangement is different from the last
            if 0..(seats.rows * seats.cols - 1)
            |> Enum.all?(fn index ->
                :array.get(index, prev_arr) == :array.get(index, curr_arr)
            end) do
                nil
            else
                {curr_arr, curr_arr}
            end
        end)
        |> Enum.to_list
        |> List.last
    end
    defp adjacent_not_occupied?(curr_index, grid, rows, cols, lookup_func) do
        lookup_func.(curr_index, grid, rows, cols)
        |> Enum.all?(fn i ->
            i == nil || :array.get(i, grid) != :occupied
        end)
    end
    defp adjacent_has_seat_count?(curr_index, grid, rows, cols, seat_type, count, lookup_func) do
        lookup_func.(curr_index, grid, rows, cols)
        |> Enum.count(fn i ->
            i != nil && :array.get(i, grid) == seat_type
        end) >= count
    end
    defp get_adjacent_seats(curr_index, _grid, rows, cols) do
        left = curr_index - 1
        right = curr_index + 1
        up = curr_index - cols
        down = curr_index + cols
        tl = curr_index - cols - 1
        tr = curr_index - cols + 1
        bl = curr_index + cols - 1
        br = curr_index + cols + 1
        [left, right, up, down, tl, tr, bl, br]
        |> Enum.map(fn x ->
            cond do
                x >= 0 && x < rows * cols && abs(rem(x, cols) - rem(curr_index, cols)) <= 1 -> x
                true -> nil
            end
        end)
    end
    defp get_visible_seats(curr_index, grid, rows, cols) do
        left = div(curr_index, cols) * cols..curr_index
        |> Enum.reverse
        |> Enum.drop(1)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        right = div(curr_index + cols, cols) * cols..curr_index
        |> Enum.drop(1)
        |> Enum.reverse
        |> Enum.drop(1)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        up = 0..div(curr_index, cols)
        |> Enum.map(fn x -> x * cols + rem(curr_index, cols) end)
        |> Enum.reverse
        |> Enum.drop(1)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        down = div(curr_index, cols)..rows - 1
        |> Enum.map(fn x -> x * cols + rem(curr_index, cols) end)
        |> Enum.drop(1)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        tl = 0..div(curr_index, cols)
        |> Enum.zip(div(curr_index, cols)..0)
        |> Enum.map(fn {x, i} -> x * cols + rem(curr_index, cols) - i end)
        |> Enum.reverse
        |> Enum.drop(1)
        |> Enum.zip(div(curr_index, cols)..0)
        |> Enum.filter(fn {x, i} -> x >= (i - 1) * cols end)
        |> Enum.map(fn {x, _i} -> x end)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        tr = 0..div(curr_index, cols)
        |> Enum.zip(div(curr_index, cols)..0)
        |> Enum.map(fn {x, i} -> x * cols + rem(curr_index, cols) + i end)
        |> Enum.reverse
        |> Enum.drop(1)
        |> Enum.zip(div(curr_index, cols)..0)
        |> Enum.filter(fn {x, i} -> x < i * cols end)
        |> Enum.map(fn {x, _i} -> x end)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        bl = div(curr_index, cols)..rows - 1
        |> Enum.with_index
        |> Enum.map(fn {x, i} -> x * cols + rem(curr_index, cols) - i end)
        |> Enum.zip(div(curr_index, cols)..rows - 1)
        |> Enum.drop(1)
        |> Enum.filter(fn {x, i} -> x >= i * cols end)
        |> Enum.map(fn {x, _i} -> x end)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)
        
        br = div(curr_index, cols)..rows - 1
        |> Enum.with_index
        |> Enum.map(fn {x, i} -> x * cols + rem(curr_index, cols) + i end)
        |> Enum.zip(div(curr_index, cols)..rows - 1)
        |> Enum.drop(1)
        |> Enum.filter(fn {x, i} -> x < (i + 1) * cols end)
        |> Enum.map(fn {x, _i} -> x end)
        |> Enum.find(fn x -> :array.get(x, grid) != :floor end)

        [left, right, up, down, tl, tr, bl, br]
    end
end

defmodule SeatParser do
    def parse_file(filename) do
        lists = File.read!(filename)
        |> String.split("\n")
        |> Enum.drop(-1)
        |> Enum.map(&(String.split(&1, "", trim: true)))
        |> Enum.map(fn row ->
            row
            |> Enum.map(fn chr ->
                case chr do
                    "L" -> :empty
                    "." -> :floor
                    "#" -> :occupied
                end
            end)
        end)
        rows = length(lists)
        cols = length(List.first(lists))
        %{grid: lists
            |> Enum.with_index
            |> Enum.reduce(:array.new(rows * cols), fn curr, acc ->
                row_index = curr |> elem(1)
                list = curr |> elem(0)
                list
                |> Enum.with_index
                |> Enum.reduce(acc, fn curr, acc ->
                    col_index = curr |> elem(1)
                    val = curr |> elem(0)
                    :array.set(row_index * cols + col_index, val, acc)
                end)
            end),
        rows: rows,
        cols: cols}
    end
end

defmodule SeatPrinter do
    def print_seats(seats, rows, cols) do
        IO.puts("----------")
        Enum.each(0..rows - 1, fn i ->
            Enum.each(0..cols - 1, fn j ->
                case :array.get(i * cols + j, seats) do
                    :occupied -> IO.write("#")
                    :empty -> IO.write("L")
                    :floor -> IO.write(".")
                end
            end)
            IO.write("\n")
        end)
        IO.puts("----------")
    end
end

if (length(System.argv) == 0) do
    IO.puts(:stderr, "Please provide a filename")
    System.halt(1)
end

[filename | _] = System.argv
# |> IO.inspect
seats = SeatParser.parse_file(filename)
# |> IO.inspect
# Part 1
seats
|> Solution.calculate_seat_ordering_count(:adjacent)
|> IO.inspect
# Part 2
# SeatPrinter.print_seats(seats.grid, seats.rows, seats.cols)
seats
|> Solution.calculate_seat_ordering_count(:visible)
|> IO.inspect
