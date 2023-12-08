import Foundation

class AOC_2023_3: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_3() }

	struct Coordinate: Hashable {
		let x: Int, y: Int
		var previous: Coordinate { Coordinate(x: x, y: y - 1) }
		var next: Coordinate { Coordinate(x: x, y: y + 1) }
	}

	func string(_ lines: [String], at coordinate: Coordinate) -> String? {
		if 0 > coordinate.x || 0 > coordinate.y || coordinate.x == lines.count { return nil }
		let x = lines[coordinate.x] as NSString
		if coordinate.y == x.length { return nil }
		let asciiValue = x.character(at: coordinate.y)
		return String(Character(Unicode.Scalar(asciiValue)!))
	}

	func with(_ lines: [String], symbols: Set<String.Element>, onResult: (Int) -> Void, onEndOfSymbol: () -> Void = {}) {
		var visitedCoordinates = [Coordinate: Bool]()
		for x in 0..<lines.count {
			for y in 0..<lines[x].count {
				guard symbols.contains(string(lines, at: Coordinate(x: x, y: y))!) else { continue }

				for possibleX in x - 1...x + 1 {
					for possibleY in y - 1...y + 1 {
						var possibleCoordinate = Coordinate(x: possibleX, y: possibleY)
						guard !(visitedCoordinates[possibleCoordinate] ?? false) else { continue }
						guard var value = string(lines, at: possibleCoordinate), value.first!.isNumber else { continue }

						// scan left to find larger digits (e.g. in xyz, and at position y: find x)
						repeat {
							possibleCoordinate = possibleCoordinate.previous
							visitedCoordinates[possibleCoordinate] = true
							guard let neighbor = string(lines, at: possibleCoordinate), neighbor.first!.isNumber else { break }
							value = neighbor + value
						} while true

						// scan right to find smaller digits (e.g. in xyz, and at position y: find z)
						possibleCoordinate = Coordinate(x: possibleX, y: possibleY)
						repeat {
							possibleCoordinate = possibleCoordinate.next
							visitedCoordinates[possibleCoordinate] = true
							guard let neighbor = string(lines, at: possibleCoordinate), neighbor.first!.isNumber else { break }
							value = value + neighbor
						} while true
						onResult(Int(value)!)
					}
				}
			}
			onEndOfSymbol()
		}
	}

	func partOne(useSampleData: Bool) -> Int {
		let input = (useSampleData ? AOC_2023_3.sample : AOC_2023_3.real)
		let lines = input.components(separatedBy: "\n")

		let symbols = Set(input.filter { !$0.isNumber && !$0.isWhitespace && $0 != "." })
		var result = 0
		with(lines, symbols: symbols, onResult: { next in
			result += next
		})
		return result
	}

	func partTwo(useSampleData: Bool) -> Int {
		let lines = (useSampleData ? AOC_2023_3.sample : AOC_2023_3.real)
						.components(separatedBy: "\n")
		var result = 0
		var products = [Int]()
		with(lines, symbols: Set("*"), onResult: { next in
			products.append(next)
		}, onEndOfSymbol: {
			if products.count == 2 {
				result += products.first! * products.last!
			}
			products.removeAll()
		})
		return result
	}
}
