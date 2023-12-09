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

	@Flag(help: "set up files for the next day. may be combined with --day and --year.")
	var begin = false

	@Flag(help: "use real data for testing? set to true when ready.")
	var realData = false

	@Flag(help: "avoid running part one?")
	var disableOne = false

	@Flag(help: "avoid running part two?")
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

		if begin {
			prepare(dayToPrepare: dayToRun + 1, yearToPrepare: yearToRun)
		} else {
			run(solutions, dayToRun: dayToRun, yearToRun: yearToRun)
		}
	}

	func run(_ solutions: [Int: [Int: Solution]], dayToRun: Int, yearToRun: Int) {
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

	func prepare(dayToPrepare: Int, yearToPrepare: Int) {
		let solution = """
import Foundation

class AOC_\(yearToPrepare)_\(dayToPrepare): NSObject, Solution {
	static func solver() -> Solution { AOC_\(yearToPrepare)_\(dayToPrepare)() }

	func partOne(useSampleData: Bool) -> Output {
		_ = (useSampleData ? AOC_\(yearToPrepare)_\(dayToPrepare).sample : AOC_\(yearToPrepare)_\(dayToPrepare).real)
		return .int(0)
	}

	func partTwo(useSampleData: Bool) -> Output {
		_ = (useSampleData ? AOC_\(yearToPrepare)_\(dayToPrepare).sample : AOC_\(yearToPrepare)_\(dayToPrepare).real)
		return .int(0)
	}
}

"""
		let solutionPath = "Sources/\(yearToPrepare)/\(yearToPrepare)_\(dayToPrepare).swift"
		try! solution.write(to: URL(fileURLWithPath: solutionPath), atomically: true, encoding: .utf8)

		let tripleQuotes = "\"\"\""
		let input = """
extension AOC_\(yearToPrepare)_\(dayToPrepare) {
	static let sample = \(tripleQuotes)
\(tripleQuotes)

	static let real = \(tripleQuotes)
\(tripleQuotes)
}

"""

		let inputPath = "Sources/\(yearToPrepare)/\(yearToPrepare)_\(dayToPrepare)+Data.swift"
		try! input.write(to: URL(fileURLWithPath: inputPath), atomically: true, encoding: .utf8)
	}
}
