import Foundation

class AOC_2023_7: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_7() }

	func sortedCharacter(_ rank: String, _ x: Character, _ y: Character) -> Bool {
		rank.distance(from: rank.startIndex, to: rank.firstIndex(of: x)!)
			>
		rank.distance(from: rank.startIndex, to: rank.firstIndex(of: y)!)
	}

	func partOne(useSampleData: Bool) -> Output {
		func histogram(_ word: String) -> [Character: Int] {
			word.reduce(into: [Character: Int]()) {
				$0[$1] = ($0[$1] ?? 0) + 1
			}
		}

		let rank = "AKQJT98765432"

		let victories: [([Character: Int]) -> Bool] = [
			{ $0.keys.count == 1 }, // 5 of a kind
			{ $0.values.sorted() == [1, 4] }, // 4 of a kind
			{ $0.values.sorted() == [2, 3] }, // full house
			{ $0.values.sorted().suffix(1) == [3] }, // three of a kind
			{ $0.values.sorted().suffix(2) == [2, 2] }, // two pair
			{ $0.values.sorted().last! == 2 }, // one pair
			{ _ in true }, // high card
		]

		return .int((useSampleData ? AOC_2023_7.sample : AOC_2023_7.real)
			.components(separatedBy: "\n")
			.sorted(by: {
				let x = $0.components(separatedBy: " ").first!
				let y = $1.components(separatedBy: " ").first!

				let xRank = victories.firstIndex { f in f(histogram(x)) }!
				let yRank = victories.firstIndex { f in f(histogram(y)) }!

				if xRank == yRank {
					let firstDistinctCharacter = zip(x, y).first { $0.0 != $0.1 }!
					return sortedCharacter(rank, firstDistinctCharacter.0, firstDistinctCharacter.1)
				}

				return xRank > yRank
			}).enumerated().reduce(0) {
				$0 + (Int($1.element.components(separatedBy: " ").last!)! * ($1.offset + 1))
			}
		)
	}

	func partTwo(useSampleData: Bool) -> Output {
		func histogram(_ rank: String, _ word: String) -> [Character: Int] {
			var scores = word.reduce(into: [Character: Int]()) {
				$0[$1] = ($0[$1] ?? 0) + 1
			}

			if let jScore = scores["J"], jScore != 5 {
				scores["J"] = nil

				let maxValue = scores.values.max()
				let bestCharacter = scores.keys.filter { scores[$0] == maxValue }.sorted { sortedCharacter(rank, $0, $1) }.first!
				scores[bestCharacter] = jScore + maxValue!
			}
			return scores
		}

		let rank = "AKQT98765432J"
		return .int((useSampleData ? AOC_2023_7.sample : AOC_2023_7.real)
			.components(separatedBy: "\n")
			.map { $0.components(separatedBy: " ") }
			.sorted(by: {
				let x = $0.first!
				let y = $1.first!

				if let firstDifferringCount = (zip(
					histogram(rank, x).values.sorted().reversed(),
					histogram(rank, y).values.sorted().reversed()
				).first { $0 != $1 }) {
					return firstDifferringCount.0 < firstDifferringCount.1
				}

				let firstDistinctCharacter = zip(x, y).first { $0.0 != $0.1 }!
				return
					rank.distance(from: rank.startIndex, to: rank.firstIndex(of: firstDistinctCharacter.0)!)
							>
					rank.distance(from: rank.startIndex, to: rank.firstIndex(of: firstDistinctCharacter.1)!)
			})
			.enumerated()
			.reduce(0) {
				$0 + (Int($1.element.last!)! * ($1.offset + 1))
			}
		)
	}
}
