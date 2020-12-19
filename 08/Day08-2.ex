defmodule Solution do
    :nop
    :acc
    :jmp

    def run_program(code) do
        Stream.unfold(%{
            acc: 0,
            pc: 0,
            ran: [],
            terminated: false
        }, fn map ->
            cond do
                map.pc in map.ran -> nil
                # Hack to make the Stream.unfold end with terminated: true
                # Set PC to 0 so that above case evaluates to true and exits with terminated set to true
                map.terminated -> {map, %{
                    acc: map.acc,
                    pc: 0,
                    ran: map.ran,
                    terminated: true
                }}
                map.pc >= length(Map.keys(code)) -> {map, %{
                    acc: map.acc,
                    pc: map.pc,
                    ran: map.ran,
                    terminated: true
                }}
                true -> 
                    instruction = code[map.pc]
                    jump = case instruction.op do
                        :jmp -> instruction.arg
                        _ -> 1
                    end
                    acc = case instruction.op do
                        :acc -> instruction.arg
                        _ -> 0
                    end
                    {map, %{
                        acc: map.acc + acc,
                        pc: map.pc + jump,
                        ran: [map.pc | map.ran],
                        terminated: false
                    }}
            end
        end)
        |> Enum.to_list
        |> List.last
    end
    def check_loop_acc(code) do
        run_program(code).acc
    end
    # Start at the bottom, find any non-zero jmp or nop and swap them, then try it
    def uncorrupt_and_check_acc(code) do
        Stream.unfold(length(Map.keys(code)) - 1, fn
            -1 -> nil
            n -> 
                item = code[n]
                replaced_item = cond do
                    (item.op == :nop or item.op == :jmp) and item.arg != 0 -> %{
                        op: case item.op do
                            :jmp -> :nop
                            :nop -> :jmp
                            op -> op
                        end,
                        arg: item.arg
                    }
                    true -> nil
                end
                if replaced_item != nil do
                    result = Map.put(code, n, replaced_item)
                    |> run_program
                    if result.terminated do
                        {result.acc, -1}
                    else
                        {n, n-1}
                    end
                else
                    {n, n-1}
                end
        end)
        |> Enum.to_list
        |> List.last
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
IO.inspect(Solution.uncorrupt_and_check_acc(code))
