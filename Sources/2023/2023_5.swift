import os
import Foundation

class AOC_2023_5: NSObject, Solution {
	static func solver() -> Solution { AOC_2023_5() }

	func partOne(useSampleData: Bool) -> Output {
		struct DisjointedRange<T: Comparable> {
			var ranges = [Range<T>]()

			func contains(_ value: T) -> Bool {
				ranges.reduce(false) { $0 || $1 ~= value }
			}
		}

		class Map {
			var source = DisjointedRange<Int>()
			var destination = DisjointedRange<Int>()
		}

		var seeds = [Int]()
		var seedRanges = [Range<Int>]()
		var maps = [String: Map]()

		var activeMap: Map? = nil
		var orderedMapKeys = [String]()

		let input = (useSampleData ? AOC_2023_5.sample : AOC_2023_5.real)
		for line in input.components(separatedBy: "\n") {
			if line.starts(with: "seeds") {
				let values = line.components(separatedBy: ": ").last!.components(separatedBy: " ").compactMap { Int($0) }

				// for part 1
				seeds += line.components(separatedBy: ": ").last!.components(separatedBy: " ").compactMap { Int($0) }

				// for part 2
				for i in stride(from: 0, to: values.count, by: 2) {
					seedRanges.append(values[i]..<values[i] + values[i + 1])
				}
			} else if line.hasSuffix(":") {
				maps[line] = Map()
				activeMap = maps[line]
				orderedMapKeys.append(line)
			} else if !line.isEmpty {
				let components = line.components(separatedBy: " ").compactMap { Int($0) }
				activeMap?.destination.ranges.append(components[0]..<(components[0] + components[2]))
				activeMap?.source.ranges.append(components[1]..<(components[1] + components[2]))
			}
		}

		var minValue = Int.max
		for seed in seeds {
			var searchingForValue = seed
			for key in orderedMapKeys {
				let map = maps[key]!
				var found = false
				for (source, destination) in zip(map.source.ranges, map.destination.ranges) {
					if !found, source ~= searchingForValue {
						let distanceIntoSource = searchingForValue - source.lowerBound
						let destinationValue = destination.lowerBound + distanceIntoSource
						searchingForValue = destinationValue
						found = true
					}
				}
			}
			minValue = min(minValue, searchingForValue)
		}
		return .int(minValue)
	}

	func partTwo(useSampleData: Bool) -> Output {
		class Map {
			var source = [Range<Int>]()
			var destination = [Range<Int>]()
		}

		var seeds = [Range<Int>]()
		var maps = [Map]()

		let input = (useSampleData ? AOC_2023_5.sample : AOC_2023_5.real)
		for line in input.components(separatedBy: "\n") {
			if line.starts(with: "seeds") {
				let values = line.components(separatedBy: ": ").last!.components(separatedBy: " ").compactMap { Int($0) }
				for i in stride(from: 0, to: values.count, by: 2) {
					seeds.append(values[i]..<values[i] + values[i + 1])
				}
			} else if line.hasSuffix(":") {
				maps.append(Map())
			} else if !line.isEmpty {
				let components = line.components(separatedBy: " ").compactMap { Int($0) }
				maps.last!.destination.append(components[0]..<(components[0] + components[2]))
				maps.last!.source.append(components[1]..<(components[1] + components[2]))
			}
		}

		let l = OSAllocatedUnfairLock()
		var minValue = Int.max
		for range in seeds {
			DispatchQueue.concurrentPerform(iterations: range.upperBound - range.lowerBound) { i in
				var searchingForValue = range.lowerBound + i
				for map in maps {
					var found = false

					for i in 0..<map.source.count where !found {
						if map.source[i] ~= searchingForValue {
							searchingForValue = map.destination[i].lowerBound + searchingForValue - map.source[i].lowerBound
							found = true
						}
					}
				}

				l.lock()
				minValue = min(minValue, searchingForValue)
				l.unlock()
			}
		}

		return .int(minValue)
	}
}
