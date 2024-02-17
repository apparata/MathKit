import Foundation
import simd

extension simd_float4x4 {

    /// Creates a 3D rotation transform that rotates around the Z axis by the angle that you provide
    /// - Parameter radians: The amount (in radians) to rotate around the Z axis.
    /// - Returns: A Z-axis rotation transform.
    public static func rotationAroundZAxis(_ radians: Float) -> simd_float4x4 {
        simd_float4x4(
            SIMD4<Float>(cos(radians), sin(radians), 0, 0),
            SIMD4<Float>(-sin(radians), cos(radians), 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
    }

    /// Creates a 3D rotation transform that rotates around the X axis by the angle that you provide
    /// - Parameter radians: The amount (in radians) to rotate around the X axis.
    /// - Returns: A X-axis rotation transform.
    public static func rotationAroundXAxis(_ radians: Float) -> simd_float4x4 {
        simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, cos(radians), sin(radians), 0),
            SIMD4<Float>(0, -sin(radians), cos(radians), 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
    }

    /// Creates a 3D rotation transform that rotates around the Y axis by the angle that you provide
    /// - Parameter radians: The amount (in radians) to rotate around the Y axis.
    /// - Returns: A Y-axis rotation transform.
    public static func rotationAroundYAxis(_ radians: Float) -> simd_float4x4 {
        simd_float4x4(
            SIMD4<Float>(cos(radians), 0, -sin(radians), 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(sin(radians), 0, cos(radians), 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
    }

    /// Returns the rotational transform component from a homogeneous matrix.
    /// - Parameter matrix: The homogeneous transform matrix.
    /// - Returns: The 3x3 rotation matrix.
    public static func rotation(_ matrix: simd_float4x4) -> simd_float3x3 {
        // Extract the rotational component from the transform matrix
        let (column1, column2, column3, _) = matrix.columns
        let rotationTransform = simd_float3x3(
            SIMD3<Float>(x: column1.x, y: column1.y, z: column1.z),
            SIMD3<Float>(x: column2.x, y: column2.y, z: column2.z),
            SIMD3<Float>(x: column3.x, y: column3.y, z: column3.z)
        )
        return rotationTransform
    }
}

