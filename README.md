#### Hello
Hey

#### So what is this
My lil environment for managing [Advent Of Code](https://adventofcode.com/) solutions. I call it `aoc` for hopefully obvious reasons.

#### What does it do
Manages all my Advent of Code solutions. Lets me run any one of them on the fly via `--day` and `--year` parameters, otherwise picks the most recent solution to run.

Through the `--real-data` flag, `aoc` can switch to solution input instead of sample input.

And, `aoc` will show how long it takes for a solution to run automatically.

#### How does `aoc` know what to do?
Command line arguments. And the Objective-C runtime.

Every solution in `aoc` follows a strict naming convention for classes, and anything following this pattern will be loaded automatically. The pattern is: `AOC_` + `year` + `_` + `day` + `.swit`, or as an example, `AOC_2025_25.swift`.

Informally, I also have a `+Data.swift` extensions to hold real and sample inputs.

#### Anything else
Consider running in release mode `swift run --configuration release aoc --real-data`.

If you clone this repo (`git clone git@github.com:zadr/aoc.git`), cd into it (`cd aoc`), and `swift run aoc --help` you'll get the full help menu.
