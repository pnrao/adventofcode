# Parse and solve
defmodule AdventOfCode.Y2025.Day02 do
  defp parse(<<dir::binary-size(1), num::binary>>) do
    {dir, String.to_integer(num)}
  end

  def part1(_input) do
    :ok
  end

  def part2(_input) do
    :ok
  end

  def run do
    # input = ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
    input = AdventOfCode.read_input() |> String.split()

    IO.puts("Day02")
    # IO.inspect(rotate_count_zeros(0, 0, 299))
    IO.puts(part1(input))
    IO.puts(part2(input))
  end
end
