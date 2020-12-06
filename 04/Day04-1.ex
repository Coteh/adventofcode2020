defmodule Solution do
    def count_valid_passports(passports) do
        Enum.count(passports, &(is_valid_passport(&1)))
    end
    def is_valid_passport(passport) do
        required_keys = [:ecl, :pid, :eyr, :hcl, :byr, :iyr, :hgt]
        optional_keys = [:cid]
        has_all_required = required_keys |> Enum.all?(&(Map.has_key?(passport, &1)))
        if !has_all_required do
            false
        else
            remaining_keys = Enum.map(passport, fn {key, _} -> key end) |> Enum.filter(&(!Enum.member?(required_keys, &1)))
            if length(remaining_keys) > 0 do
                uniq_sorted(remaining_keys) == uniq_sorted(optional_keys)
            else
                true
            end
        end
    end
    defp uniq_sorted(list) do
        Enum.sort(Enum.uniq(list))
    end
end

defmodule PassportParser do
    def parse_file(filename) do
        Enum.map(Enum.filter(Enum.chunk_by(process_file(filename), &(&1 == "")), &(&1 != [""])), &(parse_passport_lines(&1)))
    end
    def parse_passport_lines(passport_lines) do
        intermediate = Enum.flat_map(Enum.map(passport_lines, &(String.split(&1, " "))), &(&1))
        intermediate = Enum.map(intermediate, &(String.split(&1, ":")))
        keys = Enum.map(intermediate, &(List.first(&1)) |> String.to_atom())
        values = Enum.map(intermediate, &(List.last(&1)))
        Enum.zip(keys, values) |> Enum.into(%{})
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
passports = PassportParser.parse_file(filename)
# IO.inspect(passports)
# IO.inspect(Solution.is_valid_passport(Enum.at(passports, 0)))
IO.puts(Solution.count_valid_passports(passports))
