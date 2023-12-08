import Foundation

extension String {
	func lines() -> [String] {
		components(separatedBy: "\n")
	}

	func enumerateLines(_ block: (String) -> Void) {
		lines().forEach(block)
	}

	func dropDescription() -> String {
		components(separatedBy: ":").last!
	}

	func ints() -> [Int] {
		components(separatedBy: " ").compactMap { Int($0) }
	}
}
