import Foundation

class AOC_2023_9: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_9() }

	func run(
		_ useSampleData: Bool,
		nextElement: ([Int]) -> Int,
		prediction: (Int, Int) -> Int,
		insertionIndex: ([Int]) -> Int,
		summary: ([[Int]]) -> Int
	) -> Output {
		let lines = (useSampleData ? AOC_2023_9.sample : AOC_2023_9.real)
			.lines()
			.map { $0.ints() }

		var allPredictionSets = [[[Int]]]()
		var activePredictionSet = [[Int]]()
		for line in lines {
			activePredictionSet.append(line)
			repeat {
				let nextSet = activePredictionSet.last!.adjacentPairs().map { $0.1 - $0.0 }
				activePredictionSet.append(nextSet)
			} while activePredictionSet.last!.reduce(0, +) != 0
			allPredictionSets.append(activePredictionSet)
			activePredictionSet = [[Int]]()
		}

		for i in 0..<allPredictionSets.count {
			var predictionSet = allPredictionSets[i]
			for j in (0..<predictionSet.count - 1).reversed() {
				var predictionLine = predictionSet[j]
				let element = prediction(nextElement(predictionLine), nextElement(predictionSet[j + 1]))
				predictionLine.insert(element, at: insertionIndex(predictionLine))
				predictionSet[j] = predictionLine
			}
			allPredictionSets[i] = predictionSet
		}

		return .int(allPredictionSets.map(summary).reduce(0, +))
	}

	func partOne(useSampleData: Bool) -> Output {
		run(
			useSampleData,
			nextElement: { $0.last! },
			prediction: { $0 + $1 },
			insertionIndex: { $0.count },
			summary: { $0.first!.last! }
		)
	}

	func partTwo(useSampleData: Bool) -> Output {
		run(
			useSampleData,
			nextElement: { $0.first! },
			prediction: { $0 - $1 },
			insertionIndex: { _ in 0 },
			summary: { $0.first!.first! }
		)
	}
}
