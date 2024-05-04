import Foundation
import simd

extension simd_quatf {

    /// Initialize quaternion from Euler angles in radians.
    public init(yaw: Float, pitch: Float, roll: Float) {
        let cosRoll = cos(roll * 0.5)
        let sinRoll = sin(roll * 0.5)
        let cosPitch = cos(pitch * 0.5)
        let sinPitch = sin(pitch * 0.5)
        let cosYaw = cos(yaw * 0.5)
        let sinYaw = sin(yaw * 0.5)
        self.init(vector: [
            sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw,
            cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw,
            cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw,
            cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw
        ])
    }

    /// Quaternion converted to Euler angles.
    public var euler: SIMD3<Float> {
        simd_matrix4x4(self).euler
    }
}
