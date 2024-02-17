import Foundation
import simd

extension SIMD4 {

    /// Represents one of the four elements of a SIMD4
    public enum Element {
        case x
        case y
        case z
        case w
    }

    /// Returns the value of one of the SIMD4 elements.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD4<Float>(x: 1, y: 2, z: 3, w: 4)
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
        case .w: w
        }
    }
}
