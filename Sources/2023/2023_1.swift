import Foundation

class AOC_2023_1: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_1() }

	func partOne(useSampleData: Bool) -> Output {
		.int((useSampleData ? AOC_2023_1.sample1 : AOC_2023_1.real)
			.split(separator: "\n")
			.map { $0.trimmingCharacters(in: .lowercaseLetters) }
			.reduce(0) { accumulator, next in
				let tens = Int(String(next.first!))! * 10
				let ones = Int(String(next.last!))!
				return accumulator + tens + ones
			}
		)
	}

	func partTwo(useSampleData: Bool) -> Output {
		let formatter = NumberFormatter()
		formatter.numberStyle = .spellOut

		let regex = try! Regex((0...9).map { formatter.string(from: NSNumber(value: $0))! }.joined(separator: "|") + "|\\d")
		return .int((useSampleData ? AOC_2023_1.sample2 : AOC_2023_1.real)
			.split(separator: "\n")
			.reduce(0) { accumulator, line in
				var foundMatchRanges = Set<Range<String.Index>>()

				var copy = line
				while !copy.isEmpty {
					let matches = copy.matches(of: regex).map { $0.range }
					foundMatchRanges.formUnion(matches)
					copy.removeFirst()
				}

				let sortedMatches = foundMatchRanges.sorted {
					line.distance(from: line.startIndex, to: $1.lowerBound) > line.distance(from: line.startIndex, to: $0.lowerBound)
				}

				func number(from range: Range<String.Index>) -> Int {
					let substring = String(line[range])
					return (formatter.number(from: substring)?.intValue ?? Int(substring)!)
				}

				let tens = number(from: sortedMatches.first!) * 10
				let ones = number(from: sortedMatches.last!)
				return accumulator + tens + ones
			}
		)
	}
}
