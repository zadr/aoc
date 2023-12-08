import Foundation

private let timeFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.maximumFractionDigits = 3
    return f
}()

extension Duration {
	func formatted()-> String {
	  var time = Double(components.seconds) + (Double(components.attoseconds) / 1.0e18)
	  let unit: String
	  if time > 1.0 {
	    unit = "s"
	  } else if time > 0.001 {
	    unit = "ms"
	    time *= 1_000
	  } else if time > 0.000_001 {
	    unit = "µs"
	    time *= 1_000_000
	  } else {
	    unit = "ns"
	    time *= 1_000_000_000
	  }
	  return timeFormatter.string(from: NSNumber(value: time))! + " " + unit
	}
}
