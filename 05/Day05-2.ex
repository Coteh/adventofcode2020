defmodule Solution do
    def get_seat(seats) do
        seat_ids = get_all_seat_ids(seats)
        Enum.reduce(seat_ids, List.first(seat_ids), fn seat_id, acc ->
            if seat_id == acc do
                acc + 1
            else
                acc
            end
        end)
    end
    def get_all_seat_ids(seats) do
        Enum.sort(Enum.map(seats, &(calculate_seat_id(&1))))
    end
    def calculate_seat_id(seat) do
        row_col_map = %{
            loR: 0,
            hiR: 127,
            loC: 0,
            hiC: 7,
        }
        result = Enum.reduce(seat, row_col_map, fn direction, acc -> 
            %{
                loR: (if direction == :back, do: round((acc.hiR + acc.loR) / 2), else: acc.loR),
                hiR: (if direction == :front, do: round((acc.hiR + acc.loR) / 2) - 1, else: acc.hiR),
                loC: (if direction == :right, do: round((acc.hiC + acc.loC) / 2), else: acc.loC),
                hiC: (if direction == :left, do: round((acc.hiC + acc.loC) / 2) - 1, else: acc.hiC)
            }
        end)
        result.hiR * 8 + result.hiC
    end
end

defmodule BoardingPassParser do
    def parse_file(filename) do
        Enum.map(process_file(filename), &(parse_boarding_pass(&1)))
    end
    def parse_boarding_pass(line) do
        line
        |> String.graphemes
        |> Enum.map(fn chr ->
            case chr do
                "B" -> :back
                "F" -> :front
                "L" -> :left
                "R" -> :right
            end
        end)
    end
    defp process_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1)
    end
end

if (length(System.argv) == 0) do
    IO.puts(:stderr, "Please provide a filename")
    System.halt(1)
end

[filename | _] = System.argv
boarding_passes = BoardingPassParser.parse_file(filename)
# IO.inspect(boarding_passes)
# IO.inspect(Solution.calculate_seat_id(List.first(boarding_passes)))
IO.inspect(Solution.get_seat(boarding_passes))
