
import Foundation

public func clamp<T: Comparable> (_ value: T, min: T, max: T) -> T {
    if value < min { return min }
    if value > max { return max }
    return value
}

public func clamp<T: Comparable> (_ value: T, to range: ClosedRange<T>) -> T {
    return clamp(value, min: range.lowerBound, max: range.upperBound)
}
