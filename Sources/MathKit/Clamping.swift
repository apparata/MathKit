
import Foundation

public func clamp<T: Comparable> (_ value: T, min: T, max: T) -> T {
    if value < min { return min }
    if value > max { return max }
    return value
}
