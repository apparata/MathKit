import Foundation
import simd

extension SIMD2 {

    /// Create a new vector by swizzling the elements of the vector.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD2<Float>(x: 1, y: 2)
    /// let newVector1 = vector.swizzled(.x, .y)
    /// let newVector2 = vector.swizzled(.y, .x)
    /// let newVector3 = vector.swizzled(.x, .x)
    /// let newVector4 = vector.swizzled(.y, .y)
    /// ```
    ///
    /// - Parameter e0: The element of the vector whose value will be the x value.
    /// - Parameter e1: The element of the vector whose value will be the y value.
    /// - Returns: Returns a new vector where the elements of the original vector have been swizzled.
    public func swizzled(_ e0: Element, _ e1: Element) -> SIMD2<Scalar> {
        let newX = element(e0)
        let newY = element(e1)
        return .init(newX, newY)
    }
}
