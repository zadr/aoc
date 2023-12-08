import Foundation

class AOC_2023_8: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_8() }

	
	func partOne(useSampleData: Bool) -> Output {
		var lines = (useSampleData ? AOC_2023_8.sample1 : AOC_2023_8.real)
			.lines()

		let movement = lines.removeFirst()
		lines.removeFirst()

		let steps = lines.reduce(into: [String: [String]]()) {
			if $1.isEmpty { return }

			let components = $1.components(separatedBy: " = ")
			let values = components.last!
			$0[components.first!] = values[values.index(after: values.startIndex)..<values.index(before: values.endIndex)].components(separatedBy: ", ")
		}

		var paces = ["AAA"]

		repeat {
			for character in movement where paces.last != "ZZZ" {
				if character == "L" { paces.append(steps[paces.last!]!.first!) }
				if character == "R" { paces.append(steps[paces.last!]!.last!) }
			}
		} while paces.last != "ZZZ"

		return .int(paces.count - 1) // remove initial "AAA"
	}

	func partTwo(useSampleData: Bool) -> Output {
		func traverse(movement: String, starting: String) -> [String] {
			var paces = [starting]
			repeat {
				for character in movement where paces.last!.last! != "Z" {
					if character == "L" { paces.append(steps[paces.last!]!.first!) }
					if character == "R" { paces.append(steps[paces.last!]!.last!) }
				}
			} while paces.last!.last! != "Z"
			return paces
		}

		var lines = (useSampleData ? AOC_2023_8.sample1 : AOC_2023_8.real)
			.lines()

		let movement = lines.removeFirst()
		lines.removeFirst()

		let steps = lines.reduce(into: [String: [String]]()) {
			if $1.isEmpty { return }

			let components = $1.components(separatedBy: " = ")
			let values = components.last!
			$0[components.first!] = values[values.index(after: values.startIndex)..<values.index(before: values.endIndex)].components(separatedBy: ", ")
		}

		let totalStepsToWalk = steps
			.keys
			.filter { $0.hasSuffix("A") }
			.map { traverse(movement: movement, starting: $0) }
			.map { $0.count - 1 }

		let primeFactorsForSteps = totalStepsToWalk
			.map { primeFactors($0) }

		var allFactors = Set(primeFactorsForSteps.flatMap { $0 })

		primeFactorsForSteps
			.forEach { allFactors.formIntersection($0) }
		return .int(totalStepsToWalk
			.map { $0 / allFactors.first! }
			.reduce(1, *) * allFactors.first!
		)
	}
}
