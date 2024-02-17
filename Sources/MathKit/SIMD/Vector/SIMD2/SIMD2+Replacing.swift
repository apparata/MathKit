import Foundation
import simd

extension SIMD2 {

    /// Replaces the specified element with a new value.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD2<Float>(x: 1, y: 2)
    /// let newVector = vector.replacing(.x, 1337)
    /// ```
    ///
    /// - Parameter element: An element to replace (.x or .y)
    /// - Parameter with value:  Value to replace the current value with.
    /// - Returns: Returns a new vector where the specified element is replaced with a new value.
    public func replacing(_ element: Element, with value: Scalar) -> Self {
        switch element {
        case .x: .init(value, y)
        case .y: .init(x, value)
        }
    }

    /// Replaces the specified element with a new value, given the original value.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD2<Float>(x: 1, y: 2)
    /// let newVector = vector.replacing(.x) { $0 + 10 }
    /// ```
    ///
    /// - Parameter element: An element to replace (.x or .y)
    /// - Parameter with value:  Closure that, given the current value, returns a new value to replace the current value with.
    /// - Returns: Returns a new vector where the specified element is replaced with a new value.
    public func replacing(_ element: Element, with value: (Scalar) -> Scalar) -> Self {
        switch element {
        case .x: .init(value(x), y)
        case .y: .init(x, value(y))
        }
    }
}
