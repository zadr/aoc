import Foundation

extension String {
	func enumerateLines(_ block: (String) -> Void) {
		components(separatedBy: "\n").forEach(block)
	}

	func dropDescription() -> String {
		components(separatedBy: ":").last!
	}

	func ints() -> [Int] {
		components(separatedBy: " ").compactMap { Int($0) }
	}
}
