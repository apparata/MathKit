import simd

extension SIMD3 where Scalar == Float {

    // Local up.
    public static let up = SIMD3(0, 1, 0)

    // Local forward.
    public static let forward = SIMD3(0, 0, -1)

    // Local right.
    public static let right = SIMD3(1, 0, 0)
}

extension SIMD3 where Scalar == Double {

    // Local up.
    public static let up = SIMD3(0, 1, 0)

    // Local forward.
    public static let forward = SIMD3(0, 0, -1)

    // Local right.
    public static let right = SIMD3(1, 0, 0)
}
