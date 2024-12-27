defmodule Solution do
    :nop
    :acc
    :jmp

    def check_loop_acc(code) do
        result = Stream.unfold(%{
            acc: 0,
            pc: 0,
            ran: []
        }, fn map ->
            instruction = code[map.pc]
            jump = case instruction.op do
                :jmp -> instruction.arg
                _ -> 1
            end
            acc = case instruction.op do
                :acc -> instruction.arg
                _ -> 0
            end
            if map.pc in map.ran do
                nil
            else
                {map, %{
                    acc: map.acc + acc,
                    pc: map.pc + jump,
                    ran: [map.pc | map.ran]
                }}
            end
        end)
        |> Enum.to_list()
        |> List.last
        result.acc
    end
end

defmodule CodeParser do
    def parse_code(filename) do
        process_file(filename)
        |> Enum.map(&(String.split(&1, " ")))
        |> Enum.map(fn line ->
            %{
                op: String.to_existing_atom(List.first(line)),
                arg: case Integer.parse(List.last(line)) do
                    {int, _rest} -> int
                    :error -> 0
                end
            }
        end)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {v,k}, acc ->
            Map.put(acc, k, v)
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
code = CodeParser.parse_code(filename)
# IO.inspect(code)
IO.inspect(Solution.check_loop_acc(code))
