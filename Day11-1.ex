defmodule Solution do
    def calculate_seat_ordering_count(seats) do
        result_arr = calculate_seat_orderings(seats)
        0..(seats.rows * seats.cols - 1)
        |> Enum.count(&(:array.get(&1, result_arr) == :occupied))
    end
    def calculate_seat_orderings(seats) do
        seats.grid
        |> Stream.unfold(fn acc ->
            prev_arr = acc
            curr_arr = 0..(seats.rows * seats.cols - 1)
            |> Enum.reduce(acc, fn index, acc ->
                curr = :array.get(index, acc)
                cond do
                    curr == :empty && adjacent_not_occupied?(index, prev_arr, seats.rows, seats.cols) -> :array.set(index, :occupied, acc)
                    curr == :occupied && adjacent_has_seat_count?(index, prev_arr, seats.rows, seats.cols, :occupied, 4) -> :array.set(index, :empty, acc)
                    true -> acc
                end
            end)
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
    defp adjacent_not_occupied?(curr_index, grid, rows, cols) do
        get_adjacent_seats(curr_index, rows, cols)
        |> Enum.all?(fn i ->
            i < 0 || i >= rows * cols 
            || abs(rem(i, cols) - rem(curr_index, cols)) > 1
            || :array.get(i, grid) != :occupied
        end)
    end
    defp adjacent_has_seat_count?(curr_index, grid, rows, cols, seat_type, count) do
        get_adjacent_seats(curr_index, rows, cols)
        |> Enum.count(fn i ->
            i >= 0 && i < rows * cols 
            && abs(rem(i, cols) - rem(curr_index, cols)) <= 1
            && :array.get(i, grid) == seat_type
        end) >= count
    end
    defp get_adjacent_seats(curr_index, _rows, cols) do
        left = curr_index - 1
        right = curr_index + 1
        up = curr_index - cols
        down = curr_index + cols
        tl = curr_index - cols - 1
        tr = curr_index - cols + 1
        bl = curr_index + cols - 1
        br = curr_index + cols + 1
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
|> Solution.calculate_seat_ordering_count
|> IO.inspect
# TODO Part 2
