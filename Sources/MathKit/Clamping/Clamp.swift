import Foundation

/// Constrain a value to lie within a range, specified by a minimum
/// and a maximum value.
///
/// The min value should be less or equal to the max value. The function
/// calculates the result as `Swift.max(Swift.min(value, min), max)`.
///
/// **Example:**
///
/// ```
/// let valueIsStill5 = clamp(5, min: 1, max: 5)
/// let valueIsClampedTo7 = clamp(10, min: 1, max: 7)
/// ```
///
/// - Parameter value: The value to constrain to the range.
/// - Parameter min: The lower end value of the range.
/// - Parameter max: The higher end value of the range.
///
/// - Returns: The value constrained to the range.
///
public func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
    assert(min <= max, "The min value must be <= the max value.")
    return Swift.min(Swift.max(value, min), max)
}

/// Constrain a value to lie within a closed range.
///
/// **Example:**
///
/// ```
/// let valueIsStill5 = clamp(5, to: 1...7)
/// let valueIsClampedTo7 = clamp(10, to: 1...7)
/// ```
///
/// - Parameter value: The value to constrain to the range.
/// - Parameter range: The closed range to constrain the value to.
///
/// - Returns: The value constrained to the range.
///
public func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
    return clamp(value, min: range.lowerBound, max: range.upperBound)
}
