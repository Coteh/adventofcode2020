defmodule Solution do
    def count_valid_passwords(password_infos) do
        Enum.count(Enum.filter(Enum.map(password_infos, fn pw -> verify_password(pw) end), fn result -> result end))
    end
    def verify_password(password_info) do
        count = Enum.count(password_info.password |> String.graphemes, fn letter -> letter == password_info.letter end)
        count >= password_info.min && count <= password_info.max
    end
end

defmodule PasswordParser do
    def parse_file(filename) do
        process_file(filename) |> Enum.map(fn entry_line -> parse_line(entry_line) end)
    end
    def process_file(filename) do
        File.read!(filename) |> String.split("\n") |> Enum.drop(-1)
    end
    defp parse_line(line) do
        parsed = String.split(line, [" ", "-", ":"])
        entries = Enum.map(Enum.reject(parsed, fn x -> x == "" end), fn entry ->
            case Integer.parse(entry) do
                {int, _rest} -> int
                :error -> entry
            end
        end)
        Enum.into(Enum.zip([:min, :max, :letter, :password], entries), %{})
    end
end

[filename | _] = System.argv
pws = PasswordParser.parse_file(filename)
# IO.inspect(pws)
IO.inspect(Solution.count_valid_passwords(pws))
