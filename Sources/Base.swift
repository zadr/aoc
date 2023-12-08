enum Output: CustomStringConvertible {
	case int(Int)
	case string(String)

	var description: String {
		switch self {
		case .int(let int): "\(int)"
		case .string(let string): string
		}
	}
}

protocol Solution {
	static func solver() -> Solution

	func partOne(useSampleData: Bool) -> Output
	func partTwo(useSampleData: Bool) -> Output
}
