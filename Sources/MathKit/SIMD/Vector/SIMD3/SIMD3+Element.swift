import Foundation
import simd

extension SIMD3 {

    /// Represents one of the three elements of a SIMD3
    public enum Element {
        case x
        case y
        case z
    }

    /// Returns the value of one of the SIMD3 elements.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD3<Float>(x: 1, y: 2, z: 3)
    /// let x = vector.element(.x)
    /// ```
    ///
    /// - Parameter element: The element to return the value for.
    /// - Returns: The value of the specified element.
    public func element(_ element: Element) -> Scalar {
        switch element {
        case .x: x
        case .y: y
        case .z: z
        }
    }
}
