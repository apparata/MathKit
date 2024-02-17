import Foundation
import simd

extension SIMD3 {

    /// Create a new vector by swizzling the elements of the vector.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD3<Float>(x: 1, y: 2, z: 3)
    /// let newVector1 = vector.swizzled(.z, .x, .y)
    /// let newVector2 = vector.swizzled(.x, .x, .x)
    /// let newVector3 = vector.swizzled(.z, .y, .z)
    /// ```
    ///
    /// - Parameter e0: The element of the vector whose value will be the x value.
    /// - Parameter e1: The element of the vector whose value will be the y value.
    /// - Parameter e2: The element of the vector whose value will be the z value.
    /// - Returns: Returns a new vector where the elements of the original vector have been swizzled.
    public func swizzled(_ e0: Element, _ e1: Element, _ e2: Element) -> SIMD3<Scalar> {
        let newX = element(e0)
        let newY = element(e1)
        let newZ = element(e2)
        return .init(newX, newY, newZ)
    }

    /// Create a new SIMD2 vector by swizzling the elements of the SIMD3 vector.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let vector = SIMD3<Float>(x: 1, y: 2, z: 3)
    /// let newVector1: SIMD2<Float> = vector.swizzled(.x, .y)
    /// let newVector2 = vector.swizzled(.x, .x)
    /// let newVector3 = vector.swizzled(.z, .y)
    /// ```
    ///
    /// - Parameter e0: The element of the vector whose value will be the x value of the SIMD2.
    /// - Parameter e1: The element of the vector whose value will be the y value of the SIMD2.
    /// - Returns: Returns a new SIMD2 where the elements of the original vector have been swizzled.
    public func swizzled(_ e0: Element, _ e1: Element) -> SIMD2<Scalar> {
        let newX = element(e0)
        let newY = element(e1)
        return .init(newX, newY)
    }
}
