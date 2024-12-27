defmodule Solution do
    def get_sum_counts(respondents) do
        respondents
        |> Enum.map(&(get_answer_count(&1)))
        |> Enum.sum
    end
    def get_answer_count(respondent_group) do
        respondent_group
        |> Enum.map(&(&1 |> String.graphemes))
        |> Enum.flat_map(&(&1))
        |> Enum.uniq
        |> Enum.count
    end
end

defmodule RespondentParser do
    def parse_file(filename) do
        process_file(filename)
        |> Enum.chunk_by(&(&1 == ""))
        |> Enum.filter(&(&1 != [""]))
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
respondents = RespondentParser.parse_file(filename)
# IO.inspect(respondents)
# IO.inspect(Solution.get_answer_count(List.first(respondents)))
IO.inspect(Solution.get_sum_counts(respondents))
