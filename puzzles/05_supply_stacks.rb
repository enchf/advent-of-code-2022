=begin

--- Day 5: Supply Stacks ---

The expedition can depart as soon as the final supplies have been unloaded from the ships.
Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates,
the crates need to be rearranged.

The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed
or fall over, the crane operator will rearrange them in a series of carefully-planned steps.
After the crates are rearranged, the desired crates will be at the top of each stack.

The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask
her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input).
For example:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2

In this example, there are three stacks of crates.
Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top.
Stack 2 contains three crates; from bottom to top, they are crates M, C, and D.
Finally, stack 3 contains a single crate, P.

Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved
from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved
from stack 2 to stack 1, resulting in this configuration:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 

In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time,
so the first crate to be moved (D) ends up below the second and third crates:

        [Z]
        [N]
    [C] [D]
    [M] [P]
 1   2   3

Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time,
crate C ends up below crate M:

        [Z]
        [N]
[M]     [D]
[C]     [P]
 1   2   3

Finally, one crate is moved from stack 1 to stack 2:

        [Z]
        [N]
        [D]
[C] [M] [P]
 1   2   3

The Elves just need to know which crate will end up on top of each stack;
in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine
these together and give the Elves the message CMZ.

After the rearrangement procedure completes, what crate ends up on top of each stack?

=end

def parse_stacks(lines)
    count = lines.last.split(/\s+/).reject(&:empty?).map(&:to_i).max
    index = ->(i) { (i * 4) + 1 }

    (0...lines.size - 1)
        .reverse_each
        .map { |i| (0...count).map { |j| lines[i][index.(j)] } }
        .transpose
        .map { |stack| stack.reject { |element| element.strip.empty? } }
end

def apply_move(amount, i, j, stacks, preserve_order = false)
    source = stacks[i]
    target = stacks[j]
    start = source.size - amount
    taken = source[start...source.size]
    taken = taken.reverse unless preserve_order

    stacks[i] = stacks[i].take(start)
    stacks[j].push(*taken)
end

def print_stacks(stacks)
    puts stacks.map { |stack| stack.join('') }.join("\n")
    puts ''
end

def run(moves, stacks, preserve_order)
    moves.each { |n, source, target| apply_move(n, source - 1, target - 1, stacks, preserve_order) }
    puts stacks.map(&:last).join('')
end

stacks, moves = File
    .readlines('puzzles/05_supply_stacks.in')
    .slice_when { |line, _| line.strip.empty? }
    .to_a

part1 = parse_stacks(stacks.take(stacks.size - 1))
part2 = part1.map { |stack| stack.clone }
moves = moves.map { |move| move.split(' ') }.map { |_, n, _, source, _, target| [n, source, target].map(&:to_i) }

puts 'part 1'
run(moves, part1, false)
puts ''
print_stacks(part1)
print_stacks(part2)

=begin

--- Part Two ---

As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.
Some mud was covering the writing on the side of the crane, and you quickly wipe it away.
The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder,
and the ability to pick up and move multiple crates at once.

Again considering the example above, the crates begin in the same configuration:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

Moving a single crate from stack 2 to stack 1 behaves the same as before:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 

However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order,
resulting in this new configuration:

        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3

Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:

        [D]
        [N]
[C]     [Z]
[M]     [P]
 1   2   3

Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3

In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.
Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand
to be ready to unload the final supplies.
After the rearrangement procedure completes, what crate ends up on top of each stack?

=end

puts 'part 2'
run(moves, part2, true)
puts ''
print_stacks(part1)
print_stacks(part2)
