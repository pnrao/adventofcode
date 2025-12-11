# Parse and solve
defmodule AdventOfCode.Y2025.Day01 do
  defp parse(<<dir::binary-size(1), num::binary>>) do
    {dir, String.to_integer(num)}
  end

  # this one counts when the dial stops at zero
  defp rotate_count_zero_stops(dial, zeros, rotate) do
    dial = dial + rotate
    dial = Integer.mod(dial, 100)
    zeros = if dial == 0, do: zeros + 1, else: zeros
    {dial, zeros}
  end

  # this one counts when the dial stops at zero or crosses zero
  def rotate_count_zeros(dial, zeros, rotate) do
    zeros = zeros + abs(div(rotate, 100))
    # zeros = if dial == 0, do: zeros - 1, else: zeros
    rotate = rem(rotate, 100)

    if rotate != 0 do
      {dial, zeros}
    else
      dial = dial + rotate
      zeros = if dial <= 0 or dial >= 100, do: zeros + 1, else: zeros
      dial = Integer.mod(dial, 100)

      {dial, zeros}
    end
  end

  defp part1([], _dial, z) do
    z
  end

  defp part1([h | t], dial, z) do
    {dir, rotate} = parse(h)
    rotate = if dir == "L", do: -rotate, else: rotate
    {new_dial, new_z} = rotate_count_zero_stops(dial, z, rotate)
    part1(t, new_dial, new_z)
  end

  def part1(input) do
    part1(input, 50, 0)
  end

  defp part2([], _dial, z) do
    z
  end

  defp part2([h | t], dial, z) do
    {dir, rotate} = parse(h)
    rotate = if dir == "L", do: -rotate, else: rotate
    {new_dial, new_z} = rotate_count_zeros(dial, z, rotate)
    part2(t, new_dial, new_z)
  end

  def part2(input) do
    part2(input, 50, 0)
  end

  def run do
    # input = ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
    input = AdventOfCode.read_input() |> String.split()

    IO.inspect(rotate_count_zeros(0, 0, 299))
    IO.puts(part1(input))
    IO.puts(part2(input))
  end
end
