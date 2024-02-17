import Foundation
import simd

/// Add ``Codable`` compliance to ``simd_quatf``
extension simd_quatf: Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.vector.x, forKey: .x)
        try container.encode(self.vector.y, forKey: .y)
        try container.encode(self.vector.z, forKey: .z)
        try container.encode(self.vector.w, forKey: .w)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let x = try values.decode(Float.self, forKey: .x)
        let y = try values.decode(Float.self, forKey: .y)
        let z = try values.decode(Float.self, forKey: .z)
        let w = try values.decode(Float.self, forKey: .w)

        self = simd_quatf(vector: simd_float4(x: x, y: y, z: z, w: w))
    }

    enum CodingKeys: CodingKey {
        case x
        case y
        case z
        case w
    }
}
