import Foundation

extension BinaryInteger {

    /// Constrain the value to lie within a closed range.
    ///
    /// **Example:**
    ///
    /// ```
    /// let valueIsStill5 = 5.clamped(to: 1...7)
    /// let valueIsClampedTo7 = 10.clamped(to: 1...7)
    /// ```
    ///
    /// - Parameter value: The value to constrain to the range.
    /// - Parameter range: The closed range to constrain the value to.
    ///
    /// - Returns: The value constrained to the range.
    ///
    public func clamped(to range: ClosedRange<Self>) -> Self {
        clamp(self, to: range)
    }
}
