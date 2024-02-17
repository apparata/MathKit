import Foundation
import simd

extension simd_float4x4 {

    /// Right direction of the transform.
    public var right: SIMD3<Float> {
        let column = SIMD3(columns.0.x, columns.0.y, columns.0.z)
        return simd_normalize(column)
    }

    /// Up direction of the transform.
    public var up: SIMD3<Float> {
        let column = SIMD3(columns.1.x, columns.1.y, columns.1.z)
        return simd_normalize(column)
    }

    /// Forward direction of the transform.
    public var forward: SIMD3<Float> {
        let column = SIMD3(columns.2.x, columns.2.y, columns.2.z)
        return simd_normalize(column)
    }

    /// Translation component of the transform.
    public var translation: SIMD3<Float> {
        SIMD3(columns.3.x, columns.3.y, columns.3.z)
    }

    /// Uniform scale component of the transform.
    public var uniformScale: Float {
        columns.3.w
    }
}
