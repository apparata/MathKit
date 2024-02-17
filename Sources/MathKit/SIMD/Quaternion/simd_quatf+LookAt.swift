import simd

extension simd_quatf {

    /// Create a quaternion for transforming an entity to face a target from a position, given an up direction.
    public static func looking(
        at target: SIMD3<Float>,
        from position: SIMD3<Float>,
        up: SIMD3<Float> = .up
    ) -> simd_quatf {
        return facing(direction: target - position, up: up)
    }

    /// Create a quaternion for transforming an entity to face a direction, given an up direction.
    public static func facing(
        direction: simd_float3,
        up: simd_float3 = .up
    ) -> simd_quatf {
        var matrix = simd_float3x3()
        matrix[2] = -simd_fast_normalize(direction)
        matrix[0] = simd_fast_normalize(simd_cross(up, matrix[2]))
        matrix[1] = simd_cross(matrix[2], matrix[0])
        return simd_quatf(matrix)
    }
}
