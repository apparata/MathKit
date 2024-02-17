import Foundation
import simd

extension simd_float4x4 {

    /// Rotation part of the matrix as Euler angles.
    public var euler: SIMD3<Float> {
        SIMD3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}
