import Algorithms
import Atomics
import ArgumentParser
import Foundation

@main
struct AOC: ParsableCommand {
	@Option(help: "the day to run. defaults to the most recent day when numerically sorted.")
	var day: Int? = nil

	@Option(help: "the year to run. defaults to the latest year when numerically sorted.")
	var year: Int? = nil

	@Flag(help: "use real data for testing? set to true when ready.")
	var realData = false

	@Flag(help: "run part one? automatically used if parts 1 and 2 are discovered in separate files with _1 and _2 suffixes.")
	var disableOne = false

	@Flag(help: "run part one? automatically used if parts 1 and 2 are discovered in separate files with _1 and _2 suffixes.")
	var disableTwo = false

    mutating func run() throws {
		var solutions = [Int: [Int: Solution]]()

		for yearToAdd in 2022...2023 {
			var yearlySolutions = [Int: Solution]()
			for dayToAdd in 1...25 {
				let className = NSClassFromString("aoc.AOC_\(yearToAdd)_\(dayToAdd)") as? Solution.Type
				yearlySolutions[dayToAdd] = className?.solver()
			}
			solutions[yearToAdd] = yearlySolutions
		}

		let yearToRun = year ?? solutions.keys.sorted().last!
		let dayToRun = day ?? solutions[yearToRun]!.keys.sorted().last!

		let clock = ContinuousClock()

		print("Running \(yearToRun) day \(dayToRun)\n")

		if !disableOne {
			print("Part 1:")
			var result: Output! = nil
			let duration = clock.measure {
				result = solutions[yearToRun]?[dayToRun]?.partOne(useSampleData: !realData)
			}
			print(result!)
			print(duration.formatted())
		}
		print()
		if !disableTwo {
			print("Part 2:")
			var result: Output! = nil
			let duration = clock.measure {
				result = solutions[yearToRun]?[dayToRun]?.partTwo(useSampleData: !realData)
			}
			print(result!)
			print(duration.formatted())
		}
	}
}

