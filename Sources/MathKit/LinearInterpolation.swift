import Foundation
import simd
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public func lerp(_ a: Float, _ b: Float, _ t: Float) -> Float {
    return a + t * (b - a)
}

#if canImport(CoreGraphics)
public func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
    return a + t * (b - a)
}
#endif

public func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
    return a + t * (b - a)
}

public func lerp<T: SIMD>(_ a: T, _ b: T, _ t: T.Scalar) -> T where T.Scalar: FloatingPoint {
    return a + t * (b - a)
}
