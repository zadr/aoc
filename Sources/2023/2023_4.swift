import Foundation

class AOC_2023_4: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_4() }

	func partOne(useSampleData: Bool) -> Int {
		(useSampleData ? AOC_2023_4.sample : AOC_2023_4.real)
			.components(separatedBy: "\n")
			.map { line in
					let components = line.components(separatedBy: "|")
					let winningNumbers = components.first!.components(separatedBy: ":").last!.components(separatedBy: " ").filter { !$0.isEmpty }
					let scratchOffNumbers = components.last!.components(separatedBy: " ").filter { !$0.isEmpty }
					return winningNumbers
						.filter { scratchOffNumbers.contains($0) }
						.reduce(1) { x, _ in x * 2 }
							/ 2
				}.reduce(0, +)
	}

	func partTwo(useSampleData: Bool) -> Int {
		let scratchcardResults = (useSampleData ? AOC_2023_4.sample : AOC_2023_4.real)
			.components(separatedBy: "\n")
			.map { line in
				let components = line.components(separatedBy: "|")
				let winningNumbers = components.first!.components(separatedBy: ":").last!.components(separatedBy: " ").filter { !$0.isEmpty }.enumerated()
				let scratchOffNumbers = components.last!.components(separatedBy: " ").filter { !$0.isEmpty }
				return winningNumbers
					.filter { scratchOffNumbers.contains($0.element) }
					.count
			}

		var countOfCards = (1..<scratchcardResults.count + 1).reduce(into: [:]) { $0[$1] = 1 }
		for i in 1...(scratchcardResults.count) {
			let countOfCardsWon = scratchcardResults[i - 1]
			if countOfCardsWon == 0 { continue }

			for j in i + 1...(i + countOfCardsWon) {
				countOfCards[j]! += countOfCards[i]!
			}
		}

		return countOfCards.values.reduce(0, +)
	}
}
