import Foundation
import simd

extension SIMD2 {

    /// Represents one of the two elements of a SIMD2
    public enum Element {
        case x
        case y
    }

    /// Returns the value of one of the SIMD2 elements.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD2<Float>(x: 1, y: 2)
    /// let x = vector.element(.x)
    /// ```
    ///
    /// - Parameter element: The element to return the value for.
    /// - Returns: The value of the specified element.
    public func element(_ element: Element) -> Scalar {
        switch element {
        case .x: x
        case .y: y
        }
    }
}
