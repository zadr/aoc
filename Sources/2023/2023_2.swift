import Foundation

class AOC_2023_2: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_2() }

	func value(from tile: String, color: String) -> Int {
		if tile.contains(color) {
			return Int(tile.replacing(" \(color)", with: ""))!
		}
		return 0
	}

	func partOne(useSampleData: Bool) -> Int {
		(useSampleData ? AOC_2023_2.sample : AOC_2023_2.real)
			.components(separatedBy: "\n").reduce(0) { accumulator, line in
				let idToCubes = line.components(separatedBy: ": ")
	
				var isValid = true
				for set in idToCubes.last!.components(separatedBy: "; ") {
					for sorted in set.components(separatedBy: ", ") {
						isValid = isValid &&
							12 >= value(from: sorted, color: "red") &&
							13 >= value(from: sorted, color: "green") &&
							14 >= value(from: sorted, color: "blue")
					}
				}

				return isValid ? accumulator + Int(idToCubes.first!.replacing("Game ", with: ""))! : accumulator
			}
	}
	func partTwo(useSampleData: Bool) -> Int {
		(useSampleData ? AOC_2023_2.sample : AOC_2023_2.real)
			.components(separatedBy: "\n").reduce(0) { accumulator, line in
				var red = 0, green = 0, blue = 0
				line.components(separatedBy: ": ").last!.components(separatedBy: "; ").forEach { grab in
					for sorted in grab.components(separatedBy: ", ") {
						blue = max(blue, value(from: sorted, color: "blue"))
						green = max(green, value(from: sorted, color: "green"))
						red = max(red, value(from: sorted, color: "red"))
					}
				}
				return accumulator + (red * green * blue)
			}
		
	}
}
