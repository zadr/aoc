import Foundation

class AOC_2023_6: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_6() }

	func partOne(useSampleData: Bool) -> Output {
		let input = (useSampleData ? AOC_2023_6.sample : AOC_2023_6.real)
		let lines = input.components(separatedBy: "\n")
		let durations = lines.first!
			.components(separatedBy: "\n")
			.last!
			.components(separatedBy: " ")
			.compactMap { Int($0) }
		let records = lines.last!
			.components(separatedBy: "\n")
			.last!
			.components(separatedBy: " ")
			.compactMap { Int($0) }

		return .int(zip(durations, records).reduce(into: 1) { accumulator, pair in
			accumulator *= (1...pair.0).filter { i in (pair.0 - i) * i > pair.1 }.count
		})
	}

	func partTwo(useSampleData: Bool) -> Output {
		let input = (useSampleData ? AOC_2023_6.sample : AOC_2023_6.real)
		let lines = input.components(separatedBy: "\n")
		let duration = Int(lines
			.first!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!
		let record = Int(lines
			.last!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!

		let start = (1...duration).first { i in
			(duration - i) * (i) > record
		}!
		return .int((duration - (start * 2)) + 1)
	}

	func partTwo_b(useSampleData: Bool) -> Output {
		let input = (useSampleData ? AOC_2023_6.sample : AOC_2023_6.real)
		let lines = input.components(separatedBy: "\n")
		let duration = Int(lines
			.first!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!
		let record = Int(lines
			.last!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!

		let start = (1...duration).first { i in
			(duration - i) * (i) > record
		}!
		let end = (1...duration).reversed().first { i in
			(duration - i) * (i) > record
		}!
	
		return .int((end - start) + 1)
	}

	func partTwo_c(useSampleData: Bool) -> Output {
		let input = (useSampleData ? AOC_2023_6.sample : AOC_2023_6.real)
		let lines = input.components(separatedBy: "\n")
		let duration = Int(lines
			.first!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!
		let record = Int(lines
			.last!
			.components(separatedBy: ":")
			.last!
			.replacing(" ", with: ""))!

		var speedsThatCanWin = 0
		for i in 1...duration {
			let maxDistanceCoveredAtCurrentSpeed = (duration - i) * i
			if maxDistanceCoveredAtCurrentSpeed > record { speedsThatCanWin += 1 }
		}
		return .int(speedsThatCanWin)
	}
}
