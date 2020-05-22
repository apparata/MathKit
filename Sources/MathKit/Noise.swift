
import Foundation

/// Visually axis-decorrelated coherent noise algorithm based on the
/// Simplectic honeycomb. Ported from Java:
/// https://gist.github.com/KdotJPG/b1270127455a94ac5d19
public class Noise {
    
    private static let kStretch2D = (1.0 / sqrt(3.0) - 1.0) / 2.0
    private static let kSquish2D = (sqrt(3.0) - 1.0) / 2.0
    private static let kStretch3D = -1.0 / 6
    private static let kSquish3D = 1.0 / 3
    private static let kStretch4D = (1.0 / sqrt(5.0) - 1.0) / 4.0
    private static let kSquish4D = (sqrt(5.0) - 1.0) / 4.0
    
    private static let kNorm2D = 47.0
    private static let kNorm3D = 103.0
    private static let kNorm4D = 30.0
    
    private var perm = [Int16]()
    private var permGradIndex3D = [Int16]()
    
    
    public init(seed: Int64 = 0) {
        var source = [Int16]()
        for i in 0..<256 {
            source[i] = Int16(i)
        }
        var s: Int64 = seed * 6364136223846793005 + 1442695040888963407
        s = s * 6364136223846793005 + 1442695040888963407
        s = s * 6364136223846793005 + 1442695040888963407
        for i: Int64 in 255...0 {
            s = s * 6364136223846793005 + 1442695040888963407
            var r: Int64 = (s + 31) % (i + 1)
            if r < 0 {
                r += (i + 1)
            }
            perm[Int(i)] = source[Int(r)]
            permGradIndex3D[Int(i)] = Int16((perm[Int(i)] % Int16(Noise.gradients3D.count / 3)) * 3)
            source[Int(r)] = source[Int(i)]
        }
    }
    
    /// 2D OpenSimplex Noise.
    public func valueAt(x: Double, y: Double) -> Double {
        
        // Place input coordinates onto grid.
        let stretchOffset = (x + y) * Noise.kStretch2D
        let xs = x + stretchOffset
        let ys = y + stretchOffset
        
        // Floor to get grid coordinates of rhombus (stretched square) super-cell origin.
        var xsb: Int = fastFloor(xs)
        var ysb: Int = fastFloor(ys)
        
        // Skew out to get actual coordinates of rhombus origin. We'll need these later.
        let squishOffset: Double = Double(xsb + ysb) * Noise.kSquish2D
        let xb: Double = Double(xsb) + squishOffset
        let yb: Double = Double(ysb) + squishOffset
        
        // Compute grid coordinates relative to rhombus origin.
        let xins: Double = xs - Double(xsb)
        let yins: Double = ys - Double(ysb)
        
        // Sum those together to get a value that determines which region we're in.
        let inSum = xins + yins
        
        // Positions relative to origin point.
        var dx0 = x - xb
        var dy0 = y - yb
        
        // We'll be defining these inside the next block and using them afterwards.
        var dx_ext: Double = 0
        var dy_ext: Double = 0
        var xsv_ext: Int = 0
        var ysv_ext: Int = 0
        
        var value: Double = 0
        
        // Contribution (1,0)
        let dx1 = dx0 - 1 - Noise.kSquish2D
        let dy1 = dy0 - 0 - Noise.kSquish2D
        var attn1 = 2 - dx1 * dx1 - dy1 * dy1
        if attn1 > 0 {
            attn1 *= attn1
            value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, dx1, dy1)
        }
        
        // Contribution (0,1)
        let dx2 = dx0 - 0 - Noise.kSquish2D
        let dy2 = dy0 - 1 - Noise.kSquish2D
        var attn2 = 2 - dx2 * dx2 - dy2 * dy2
        if attn2 > 0 {
            attn2 *= attn2
            value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, dx2, dy2)
        }
        
        if inSum <= 1 { // We're inside the triangle (2-Simplex) at (0,0)
            let zins = 1 - inSum
            if zins > xins || zins > yins { // (0,0) is one of the closest two triangular vertices
                if xins > yins {
                    xsv_ext = xsb + 1
                    ysv_ext = ysb - 1
                    dx_ext = dx0 - 1
                    dy_ext = dy0 + 1
                } else {
                    xsv_ext = xsb - 1
                    ysv_ext = ysb + 1
                    dx_ext = dx0 + 1
                    dy_ext = dy0 - 1
                }
            } else { //(1,0) and (0,1) are the closest two vertices.
                xsv_ext = xsb + 1
                ysv_ext = ysb + 1
                dx_ext = dx0 - 1 - 2 * Noise.kSquish2D
                dy_ext = dy0 - 1 - 2 * Noise.kSquish2D
            }
        } else { // We're inside the triangle (2-Simplex) at (1,1)
            let zins = 2 - inSum
            if zins < xins || zins < yins { // (0,0) is one of the closest two triangular vertices
                if xins > yins {
                    xsv_ext = xsb + 2
                    ysv_ext = ysb + 0
                    dx_ext = dx0 - 2 - 2 * Noise.kSquish2D
                    dy_ext = dy0 + 0 - 2 * Noise.kSquish2D
                } else {
                    xsv_ext = xsb + 0
                    ysv_ext = ysb + 2
                    dx_ext = dx0 + 0 - 2 * Noise.kSquish2D
                    dy_ext = dy0 - 2 - 2 * Noise.kSquish2D
                }
            } else { // (1,0) and (0,1) are the closest two vertices.
                dx_ext = dx0
                dy_ext = dy0
                xsv_ext = xsb
                ysv_ext = ysb
            }
            xsb += 1
            ysb += 1
            dx0 = dx0 - 1 - 2 * Noise.kSquish2D
            dy0 = dy0 - 1 - 2 * Noise.kSquish2D
        }
        
        // Contribution (0,0) or (1,1)
        var attn0 = 2 - dx0 * dx0 - dy0 * dy0
        if attn0 > 0 {
            attn0 *= attn0
            value += attn0 * attn0 * extrapolate(xsb, ysb, dx0, dy0)
        }
        
        // Extra Vertex
        var attn_ext = 2 - dx_ext * dx_ext - dy_ext * dy_ext
        if attn_ext > 0 {
            attn_ext *= attn_ext
            value += attn_ext * attn_ext * extrapolate(xsv_ext, ysv_ext, dx_ext, dy_ext)
        }
        
        return value / Noise.kNorm2D
    }
    
    //3D OpenSimplex Noise.
    public func valueAt(x: Double, y: Double, z: Double) -> Double {
        
        // Place input coordinates on simplectic honeycomb.
        let stretchOffset = Double(x + y + z) * Noise.kStretch3D
        let xs = Double(x) + stretchOffset
        let ys = Double(y) + stretchOffset
        let zs = Double(z) + stretchOffset
        
        // Floor to get simplectic honeycomb coordinates of rhombohedron (stretched cube) super-cell origin.
        let xsb = fastFloor(xs)
        let ysb = fastFloor(ys)
        let zsb = fastFloor(zs)
        
        // Skew out to get actual coordinates of rhombohedron origin. We'll need these later.
        let squishOffset = Double(xsb + ysb + zsb) * Noise.kSquish3D
        let xb = Double(xsb) + squishOffset
        let yb = Double(ysb) + squishOffset
        let zb = Double(zsb) + squishOffset
        
        // Compute simplectic honeycomb coordinates relative to rhombohedral origin.
        let xins = xs - Double(xsb)
        let yins = ys - Double(ysb)
        let zins = zs - Double(zsb)
        
        // Sum those together to get a value that determines which region we're in.
        let inSum = xins + yins + zins
        
        // Positions relative to origin point.
        var dx0 = x - xb
        var dy0 = y - yb
        var dz0 = z - zb
        
        // We'll be defining these inside the next block and using them afterwards.
        var dx_ext0: Double
        var dy_ext0: Double
        var dz_ext0: Double
        var dx_ext1: Double
        var dy_ext1: Double
        var dz_ext1: Double
        var xsv_ext0: Int
        var ysv_ext0: Int
        var zsv_ext0: Int
        var xsv_ext1: Int
        var ysv_ext1: Int
        var zsv_ext1: Int
        
        var value: Double = 0
        if inSum <= 1 { // We're inside the tetrahedron (3-Simplex) at (0,0,0)
            
            // Determine which two of (0,0,1), (0,1,0), (1,0,0) are closest.
            var aPoint: Int8 = 0x01
            var aScore = xins
            var bPoint: Int8 = 0x02
            var bScore = yins
            if aScore >= bScore && zins > bScore {
                bScore = zins
                bPoint = 0x04
            } else if aScore < bScore && zins > aScore {
                aScore = zins
                aPoint = 0x04
            }
            
            // Now we determine the two lattice points not part of the tetrahedron that may contribute.
            // This depends on the closest two tetrahedral vertices, including (0,0,0)
            let wins = 1 - inSum
            if wins > aScore || wins > bScore { // (0,0,0) is one of the closest two tetrahedral vertices.
                let c = (bScore > aScore ? bPoint : aPoint) // Our other closest vertex is the closest out of a and b.
                
                if (c & 0x01) == 0 {
                    xsv_ext0 = xsb - 1
                    xsv_ext1 = xsb
                    dx_ext0 = dx0 + 1
                    dx_ext1 = dx0
                } else {
                    xsv_ext0 = xsb + 1
                    xsv_ext1 = xsv_ext0
                    dx_ext0 = dx0 - 1
                    dx_ext1 = dx_ext0
                }
                
                if (c & 0x02) == 0 {
                    ysv_ext0 = ysb
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0
                    dy_ext1 = dy_ext0
                    if (c & 0x01) == 0 {
                        ysv_ext1 -= 1
                        dy_ext1 += 1
                    } else {
                        ysv_ext0 -= 1
                        dy_ext0 += 1
                    }
                } else {
                    ysv_ext0 = ysb + 1
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0 - 1
                    dy_ext1 = dy_ext0
                }
                
                if (c & 0x04) == 0 {
                    zsv_ext0 = zsb
                    zsv_ext1 = zsb - 1
                    dz_ext0 = dz0
                    dz_ext1 = dz0 + 1
                } else {
                    zsv_ext0 = zsb + 1
                    zsv_ext1 = zsv_ext0
                    dz_ext0 = dz0 - 1
                    dz_ext1 = dz_ext0
                }
            } else { // (0,0,0) is not one of the closest two tetrahedral vertices.
                let c: Int8 = Int8(aPoint | bPoint) // Our two extra vertices are determined by the closest two.
                
                if (c & 0x01) == 0 {
                    xsv_ext0 = xsb
                    xsv_ext1 = xsb - 1
                    dx_ext0 = dx0 - 2 * Noise.kSquish3D
                    dx_ext1 = dx0 + 1 - Noise.kSquish3D
                } else {
                    xsv_ext0 = xsb + 1
                    xsv_ext1 = xsv_ext0
                    dx_ext0 = dx0 - 1 - 2 * Noise.kSquish3D
                    dx_ext1 = dx0 - 1 - Noise.kSquish3D
                }
                
                if (c & 0x02) == 0 {
                    ysv_ext0 = ysb
                    ysv_ext1 = ysb - 1
                    dy_ext0 = dy0 - 2 * Noise.kSquish3D
                    dy_ext1 = dy0 + 1 - Noise.kSquish3D
                } else {
                    ysv_ext0 = ysb + 1
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0 - 1 - 2 * Noise.kSquish3D
                    dy_ext1 = dy0 - 1 - Noise.kSquish3D
                }
                
                if (c & 0x04) == 0 {
                    zsv_ext0 = zsb
                    zsv_ext1 = zsb - 1
                    dz_ext0 = dz0 - 2 * Noise.kSquish3D
                    dz_ext1 = dz0 + 1 - Noise.kSquish3D
                } else {
                    zsv_ext0 = zsb + 1
                    zsv_ext1 = zsv_ext0
                    dz_ext0 = dz0 - 1 - 2 * Noise.kSquish3D
                    dz_ext1 = dz0 - 1 - Noise.kSquish3D
                }
            }
            
            // Contribution (0,0,0)
            var attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0
            if attn0 > 0 {
                attn0 *= attn0
                value += attn0 * attn0 * extrapolate(xsb + 0, ysb + 0, zsb + 0, dx0, dy0, dz0)
            }
            
            // Contribution (1,0,0)
            let dx1 = dx0 - 1 - Noise.kSquish3D
            let dy1 = dy0 - 0 - Noise.kSquish3D
            let dz1 = dz0 - 0 - Noise.kSquish3D
            var attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
            if attn1 > 0 {
                attn1 *= attn1
                value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, dx1, dy1, dz1)
            }
            
            // Contribution (0,1,0)
            let dx2 = dx0 - 0 - Noise.kSquish3D
            let dy2 = dy0 - 1 - Noise.kSquish3D
            let dz2 = dz1
            var attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
            if (attn2 > 0) {
                attn2 *= attn2
                value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, dx2, dy2, dz2)
            }
            
            // Contribution (0,0,1)
            let dx3 = dx2
            let dy3 = dy1
            let dz3 = dz0 - 1 - Noise.kSquish3D
            var attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
            if (attn3 > 0) {
                attn3 *= attn3
                value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, dx3, dy3, dz3)
            }
        } else if inSum >= 2 { // We're inside the tetrahedron (3-Simplex) at (1,1,1)
            
            // Determine which two tetrahedral vertices are the closest, out of (1,1,0), (1,0,1), (0,1,1) but not (1,1,1).
            var aPoint: Int8 = 0x06
            var aScore = xins
            var bPoint: Int8 = 0x05
            var bScore = yins
            if aScore <= bScore && zins < bScore {
                bScore = zins
                bPoint = 0x03
            } else if aScore > bScore && zins < aScore {
                aScore = zins
                aPoint = 0x03
            }
            
            // Now we determine the two lattice points not part of the tetrahedron that may contribute.
            // This depends on the closest two tetrahedral vertices, including (1,1,1)
            let wins = 3 - inSum
            if wins < aScore || wins < bScore { // (1,1,1) is one of the closest two tetrahedral vertices.
                let c: Int8 = (bScore < aScore ? bPoint : aPoint) // Our other closest vertex is the closest out of a and b.
                
                if (c & 0x01) != 0 {
                    xsv_ext0 = xsb + 2
                    xsv_ext1 = xsb + 1
                    dx_ext0 = dx0 - 2 - 3 * Noise.kSquish3D
                    dx_ext1 = dx0 - 1 - 3 * Noise.kSquish3D
                } else {
                    xsv_ext0 = xsb
                    xsv_ext1 = xsv_ext0
                    dx_ext0 = dx0 - 3 * Noise.kSquish3D
                    dx_ext1 = dx_ext0
                }
                
                if (c & 0x02) != 0 {
                    ysv_ext0 = ysb + 1
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0 - 1 - 3 * Noise.kSquish3D
                    dy_ext1 = dy_ext0
                    if (c & 0x01) != 0 {
                        ysv_ext1 += 1
                        dy_ext1 -= 1
                    } else {
                        ysv_ext0 += 1
                        dy_ext0 -= 1
                    }
                } else {
                    ysv_ext0 = ysb
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0 - 3 * Noise.kSquish3D
                    dy_ext1 = dy_ext0
                }
                
                if (c & 0x04) != 0 {
                    zsv_ext0 = zsb + 1
                    zsv_ext1 = zsb + 2
                    dz_ext0 = dz0 - 1 - 3 * Noise.kSquish3D
                    dz_ext1 = dz0 - 2 - 3 * Noise.kSquish3D
                } else {
                    zsv_ext0 = zsb
                    zsv_ext1 = zsv_ext0
                    dz_ext0 = dz0 - 3 * Noise.kSquish3D
                    dz_ext1 = dz_ext0
                }
            } else { // (1,1,1) is not one of the closest two tetrahedral vertices.
                let c: Int8 = Int8(aPoint & bPoint) // Our two extra vertices are determined by the closest two.
                
                if (c & 0x01) != 0 {
                    xsv_ext0 = xsb + 1
                    xsv_ext1 = xsb + 2
                    dx_ext0 = dx0 - 1 - Noise.kSquish3D
                    dx_ext1 = dx0 - 2 - 2 * Noise.kSquish3D
                } else {
                    xsv_ext0 = xsb
                    xsv_ext1 = xsv_ext0
                    dx_ext0 = dx0 - Noise.kSquish3D
                    dx_ext1 = dx0 - 2 * Noise.kSquish3D
                }
                
                if (c & 0x02) != 0 {
                    ysv_ext0 = ysb + 1
                    ysv_ext1 = ysb + 2
                    dy_ext0 = dy0 - 1 - Noise.kSquish3D
                    dy_ext1 = dy0 - 2 - 2 * Noise.kSquish3D
                } else {
                    ysv_ext0 = ysb
                    ysv_ext1 = ysv_ext0
                    dy_ext0 = dy0 - Noise.kSquish3D
                    dy_ext1 = dy0 - 2 * Noise.kSquish3D
                }
                
                if (c & 0x04) != 0 {
                    zsv_ext0 = zsb + 1
                    zsv_ext1 = zsb + 2
                    dz_ext0 = dz0 - 1 - Noise.kSquish3D
                    dz_ext1 = dz0 - 2 - 2 * Noise.kSquish3D
                } else {
                    zsv_ext0 = zsb
                    zsv_ext1 = zsv_ext0
                    dz_ext0 = dz0 - Noise.kSquish3D
                    dz_ext1 = dz0 - 2 * Noise.kSquish3D
                }
            }
            
            //Contribution (1,1,0)
            let dx3 = dx0 - 1 - 2 * Noise.kSquish3D
            let dy3 = dy0 - 1 - 2 * Noise.kSquish3D
            let dz3 = dz0 - 0 - 2 * Noise.kSquish3D
            var attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
            if attn3 > 0 {
                attn3 *= attn3
                value += attn3 * attn3 * extrapolate(xsb + 1, ysb + 1, zsb + 0, dx3, dy3, dz3)
            }
            
            // Contribution (1,0,1)
            let dx2 = dx3
            let dy2 = dy0 - 0 - 2 * Noise.kSquish3D
            let dz2 = dz0 - 1 - 2 * Noise.kSquish3D
            var attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
            if attn2 > 0 {
                attn2 *= attn2
                value += attn2 * attn2 * extrapolate(xsb + 1, ysb + 0, zsb + 1, dx2, dy2, dz2)
            }
            
            // Contribution (0,1,1)
            let dx1 = dx0 - 0 - 2 * Noise.kSquish3D
            let dy1 = dy3
            let dz1 = dz2
            var attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
            if attn1 > 0 {
                attn1 *= attn1
                value += attn1 * attn1 * extrapolate(xsb + 0, ysb + 1, zsb + 1, dx1, dy1, dz1)
            }
            
            // Contribution (1,1,1)
            dx0 = dx0 - 1 - 3 * Noise.kSquish3D
            dy0 = dy0 - 1 - 3 * Noise.kSquish3D
            dz0 = dz0 - 1 - 3 * Noise.kSquish3D
            var attn0 = 2 - dx0 * dx0 - dy0 * dy0 - dz0 * dz0
            if (attn0 > 0) {
                attn0 *= attn0
                value += attn0 * attn0 * extrapolate(xsb + 1, ysb + 1, zsb + 1, dx0, dy0, dz0)
            }
        } else { // We're inside the octahedron (Rectified 3-Simplex) in between.
            var aScore: Double = 0
            var aPoint: Int8 = 0
            var aIsFurtherSide: Bool = false
            var bScore: Double = 0
            var bPoint: Int8 = 0
            var bIsFurtherSide: Bool = false
            
            // Decide between point (0,0,1) and (1,1,0) as closest
            let p1 = xins + yins
            if p1 > 1 {
                aScore = p1 - 1
                aPoint = 0x03
                aIsFurtherSide = true
            } else {
                aScore = 1 - p1
                aPoint = 0x04
                aIsFurtherSide = false
            }
            
            // Decide between point (0,1,0) and (1,0,1) as closest
            let p2 = xins + zins
            if p2 > 1 {
                bScore = p2 - 1
                bPoint = 0x05
                bIsFurtherSide = true
            } else {
                bScore = 1 - p2
                bPoint = 0x02
                bIsFurtherSide = false
            }
            
            // The closest out of the two (1,0,0) and (0,1,1) will replace the furthest out of the two decided above, if closer.
            let p3 = yins + zins
            if p3 > 1 {
                let score = p3 - 1
                if aScore <= bScore && aScore < score {
                    aScore = score
                    aPoint = 0x06
                    aIsFurtherSide = true
                } else if aScore > bScore && bScore < score {
                    bScore = score
                    bPoint = 0x06
                    bIsFurtherSide = true
                }
            } else {
                let score = 1 - p3
                if aScore <= bScore && aScore < score {
                    aScore = score
                    aPoint = 0x01
                    aIsFurtherSide = false
                } else if aScore > bScore && bScore < score {
                    bScore = score
                    bPoint = 0x01
                    bIsFurtherSide = false
                }
            }
            
            // Where each of the two closest points are determines how the extra two vertices are calculated.
            if aIsFurtherSide == bIsFurtherSide {
                if aIsFurtherSide { // Both closest points on (1,1,1) side
                    
                    // One of the two extra points is (1,1,1)
                    dx_ext0 = dx0 - 1 - 3 * Noise.kSquish3D
                    dy_ext0 = dy0 - 1 - 3 * Noise.kSquish3D
                    dz_ext0 = dz0 - 1 - 3 * Noise.kSquish3D
                    xsv_ext0 = xsb + 1
                    ysv_ext0 = ysb + 1
                    zsv_ext0 = zsb + 1
                    
                    // Other extra point is based on the shared axis.
                    let c: Int8 = Int8(aPoint & bPoint)
                    if (c & 0x01) != 0 {
                        dx_ext1 = dx0 - 2 - 2 * Noise.kSquish3D
                        dy_ext1 = dy0 - 2 * Noise.kSquish3D
                        dz_ext1 = dz0 - 2 * Noise.kSquish3D
                        xsv_ext1 = xsb + 2
                        ysv_ext1 = ysb
                        zsv_ext1 = zsb
                    } else if (c & 0x02) != 0 {
                        dx_ext1 = dx0 - 2 * Noise.kSquish3D
                        dy_ext1 = dy0 - 2 - 2 * Noise.kSquish3D
                        dz_ext1 = dz0 - 2 * Noise.kSquish3D
                        xsv_ext1 = xsb
                        ysv_ext1 = ysb + 2
                        zsv_ext1 = zsb
                    } else {
                        dx_ext1 = dx0 - 2 * Noise.kSquish3D
                        dy_ext1 = dy0 - 2 * Noise.kSquish3D
                        dz_ext1 = dz0 - 2 - 2 * Noise.kSquish3D
                        xsv_ext1 = xsb
                        ysv_ext1 = ysb
                        zsv_ext1 = zsb + 2
                    }
                } else {// Both closest points on (0,0,0) side
                    
                    // One of the two extra points is (0,0,0)
                    dx_ext0 = dx0
                    dy_ext0 = dy0
                    dz_ext0 = dz0
                    xsv_ext0 = xsb
                    ysv_ext0 = ysb
                    zsv_ext0 = zsb
                    
                    // Other extra point is based on the omitted axis.
                    let c: Int8 = Int8(aPoint | bPoint)
                    if (c & 0x01) == 0 {
                        dx_ext1 = dx0 + 1 - Noise.kSquish3D
                        dy_ext1 = dy0 - 1 - Noise.kSquish3D
                        dz_ext1 = dz0 - 1 - Noise.kSquish3D
                        xsv_ext1 = xsb - 1
                        ysv_ext1 = ysb + 1
                        zsv_ext1 = zsb + 1
                    } else if (c & 0x02) == 0 {
                        dx_ext1 = dx0 - 1 - Noise.kSquish3D
                        dy_ext1 = dy0 + 1 - Noise.kSquish3D
                        dz_ext1 = dz0 - 1 - Noise.kSquish3D
                        xsv_ext1 = xsb + 1
                        ysv_ext1 = ysb - 1
                        zsv_ext1 = zsb + 1
                    } else {
                        dx_ext1 = dx0 - 1 - Noise.kSquish3D
                        dy_ext1 = dy0 - 1 - Noise.kSquish3D
                        dz_ext1 = dz0 + 1 - Noise.kSquish3D
                        xsv_ext1 = xsb + 1
                        ysv_ext1 = ysb + 1
                        zsv_ext1 = zsb - 1
                    }
                }
            } else { // One point on (0,0,0) side, one point on (1,1,1) side
                let c1: Int8 = aIsFurtherSide ? aPoint : bPoint
                let c2: Int8 = aIsFurtherSide ? bPoint : aPoint
                
                // One contribution is a permutation of (1,1,-1)
                if (c1 & 0x01) == 0 {
                    dx_ext0 = dx0 + 1 - Noise.kSquish3D
                    dy_ext0 = dy0 - 1 - Noise.kSquish3D
                    dz_ext0 = dz0 - 1 - Noise.kSquish3D
                    xsv_ext0 = xsb - 1
                    ysv_ext0 = ysb + 1
                    zsv_ext0 = zsb + 1
                } else if (c1 & 0x02) == 0 {
                    dx_ext0 = dx0 - 1 - Noise.kSquish3D
                    dy_ext0 = dy0 + 1 - Noise.kSquish3D
                    dz_ext0 = dz0 - 1 - Noise.kSquish3D
                    xsv_ext0 = xsb + 1
                    ysv_ext0 = ysb - 1
                    zsv_ext0 = zsb + 1
                } else {
                    dx_ext0 = dx0 - 1 - Noise.kSquish3D
                    dy_ext0 = dy0 - 1 - Noise.kSquish3D
                    dz_ext0 = dz0 + 1 - Noise.kSquish3D
                    xsv_ext0 = xsb + 1
                    ysv_ext0 = ysb + 1
                    zsv_ext0 = zsb - 1
                }
                
                // One contribution is a permutation of (0,0,2)
                dx_ext1 = dx0 - 2 * Noise.kSquish3D
                dy_ext1 = dy0 - 2 * Noise.kSquish3D
                dz_ext1 = dz0 - 2 * Noise.kSquish3D
                xsv_ext1 = xsb
                ysv_ext1 = ysb
                zsv_ext1 = zsb
                if (c2 & 0x01) != 0 {
                    dx_ext1 -= 2
                    xsv_ext1 += 2
                } else if (c2 & 0x02) != 0 {
                    dy_ext1 -= 2
                    ysv_ext1 += 2
                } else {
                    dz_ext1 -= 2
                    zsv_ext1 += 2
                }
            }
            
            // Contribution (1,0,0)
            let dx1 = dx0 - 1 - Noise.kSquish3D
            let dy1 = dy0 - 0 - Noise.kSquish3D
            let dz1 = dz0 - 0 - Noise.kSquish3D
            var attn1 = 2 - dx1 * dx1 - dy1 * dy1 - dz1 * dz1
            if (attn1 > 0) {
                attn1 *= attn1
                value += attn1 * attn1 * extrapolate(xsb + 1, ysb + 0, zsb + 0, dx1, dy1, dz1)
            }
            
            // Contribution (0,1,0)
            let dx2 = dx0 - 0 - Noise.kSquish3D
            let dy2 = dy0 - 1 - Noise.kSquish3D
            let dz2 = dz1
            var attn2 = 2 - dx2 * dx2 - dy2 * dy2 - dz2 * dz2
            if attn2 > 0 {
                attn2 *= attn2
                value += attn2 * attn2 * extrapolate(xsb + 0, ysb + 1, zsb + 0, dx2, dy2, dz2)
            }
            
            // Contribution (0,0,1)
            let dx3 = dx2
            let dy3 = dy1
            let dz3 = dz0 - 1 - Noise.kSquish3D
            var attn3 = 2 - dx3 * dx3 - dy3 * dy3 - dz3 * dz3
            if attn3 > 0 {
                attn3 *= attn3
                value += attn3 * attn3 * extrapolate(xsb + 0, ysb + 0, zsb + 1, dx3, dy3, dz3)
            }
            
            // Contribution (1,1,0)
            let dx4 = dx0 - 1 - 2 * Noise.kSquish3D
            let dy4 = dy0 - 1 - 2 * Noise.kSquish3D
            let dz4 = dz0 - 0 - 2 * Noise.kSquish3D
            var attn4 = 2 - dx4 * dx4 - dy4 * dy4 - dz4 * dz4
            if attn4 > 0 {
                attn4 *= attn4
                value += attn4 * attn4 * extrapolate(xsb + 1, ysb + 1, zsb + 0, dx4, dy4, dz4)
            }
            
            // Contribution (1,0,1)
            let dx5 = dx4
            let dy5 = dy0 - 0 - 2 * Noise.kSquish3D
            let dz5 = dz0 - 1 - 2 * Noise.kSquish3D
            var attn5 = 2 - dx5 * dx5 - dy5 * dy5 - dz5 * dz5
            if attn5 > 0 {
                attn5 *= attn5
                value += attn5 * attn5 * extrapolate(xsb + 1, ysb + 0, zsb + 1, dx5, dy5, dz5)
            }
            
            // Contribution (0,1,1)
            let dx6 = dx0 - 0 - 2 * Noise.kSquish3D
            let dy6 = dy4
            let dz6 = dz5
            var attn6 = 2 - dx6 * dx6 - dy6 * dy6 - dz6 * dz6
            if attn6 > 0 {
                attn6 *= attn6
                value += attn6 * attn6 * extrapolate(xsb + 0, ysb + 1, zsb + 1, dx6, dy6, dz6)
            }
        }
        
        // First extra vertex
        var attn_ext0 = 2 - dx_ext0 * dx_ext0 - dy_ext0 * dy_ext0 - dz_ext0 * dz_ext0
        if attn_ext0 > 0 {
            attn_ext0 *= attn_ext0
            value += attn_ext0 * attn_ext0 * extrapolate(xsv_ext0, ysv_ext0, zsv_ext0, dx_ext0, dy_ext0, dz_ext0)
        }
        
        // Second extra vertex
        var attn_ext1 = 2 - dx_ext1 * dx_ext1 - dy_ext1 * dy_ext1 - dz_ext1 * dz_ext1
        if attn_ext1 > 0 {
            attn_ext1 *= attn_ext1
            value += attn_ext1 * attn_ext1 * extrapolate(xsv_ext1, ysv_ext1, zsv_ext1, dx_ext1, dy_ext1, dz_ext1)
        }
        
        return value / Noise.kNorm3D
    }
    
    private func extrapolate(_ xsb: Int, _ ysb: Int, _ dx: Double, _ dy: Double) -> Double {
        let index = Int(perm[Int((Int(perm[xsb & 0xFF]) + Int(ysb)) & 0xFF)] & 0x0E)
        return Double(Noise.gradients2D[index]) * dx + Double(Noise.gradients2D[index + 1]) * dy
    }
    
    private func extrapolate(_ xsb: Int, _ ysb: Int, _ zsb: Int, _ dx: Double, _ dy: Double, _ dz: Double) -> Double {
        let a = Int(perm[xsb & 0xFF]) + ysb
        let b = Int(perm[a & 0xFF]) + Int(zsb)
        let index = Int(permGradIndex3D[b & 0xFF])
        return Double(Noise.gradients3D[index]) * dx + Double(Noise.gradients3D[index + 1]) * dy + Double(Noise.gradients3D[index + 2]) * dz
    }
    
    private func extrapolate(_ xsb: Int, _ ysb: Int, _ zsb: Int, _ wsb: Int, _ dx: Double, _ dy: Double, _ dz: Double, _ dw: Double) -> Double {
        let a = Int(perm[xsb & 0xFF]) + ysb
        let b = Int(perm[Int(a & 0xFF)]) + zsb
        let c = Int(perm[Int(b & 0xFF)]) + wsb
        let index = Int(perm[Int(c & 0xFF)] & 0xFC)
        var result = Double(Noise.gradients4D[index]) * dx
        result += Double(Noise.gradients4D[index + 1]) * dy
        result += Double(Noise.gradients4D[index + 2]) * dz
        result += Double(Noise.gradients4D[index + 3]) * dw
        return result
    }
    
    private func fastFloor(_ x: Double) -> Int {
        let xi = Int(x)
        return x < Double(xi) ? xi - 1 : xi
    }
    
    //Gradients for 2D. They approximate the directions to the
    //vertices of an octagon from the center.
    private static let gradients2D: [Int8] = [
        5,  2,    2,  5,
        -5,  2,   -2,  5,
        5, -2,    2, -5,
        -5, -2,   -2, -5,
    ]
    
    //Gradients for 3D. They approximate the directions to the
    //vertices of a rhombicuboctahedron from the center, skewed so
    //that the triangular and square facets can be inscribed inside
    //circles of the same radius.
    private static let gradients3D: [Int8] = [
        -11,  4,  4,     -4,  11,  4,    -4,  4,  11,
        11,  4,  4,      4,  11,  4,     4,  4,  11,
        -11, -4,  4,     -4, -11,  4,    -4, -4,  11,
        11, -4,  4,      4, -11,  4,     4, -4,  11,
        -11,  4, -4,     -4,  11, -4,    -4,  4, -11,
        11,  4, -4,      4,  11, -4,     4,  4, -11,
        -11, -4, -4,     -4, -11, -4,    -4, -4, -11,
        11, -4, -4,      4, -11, -4,     4, -4, -11,
    ]
    
    //Gradients for 4D. They approximate the directions to the
    //vertices of a disprismatotesseractihexadecachoron from the center,
    //skewed so that the tetrahedral and cubic facets can be inscribed inside
    //spheres of the same radius.
    private static let gradients4D: [Int8] = [
        3,  1,  1,  1,      1,  3,  1,  1,      1,  1,  3,  1,      1,  1,  1,  3,
        -3,  1,  1,  1,     -1,  3,  1,  1,     -1,  1,  3,  1,     -1,  1,  1,  3,
        3, -1,  1,  1,      1, -3,  1,  1,      1, -1,  3,  1,      1, -1,  1,  3,
        -3, -1,  1,  1,     -1, -3,  1,  1,     -1, -1,  3,  1,     -1, -1,  1,  3,
        3,  1, -1,  1,      1,  3, -1,  1,      1,  1, -3,  1,      1,  1, -1,  3,
        -3,  1, -1,  1,     -1,  3, -1,  1,     -1,  1, -3,  1,     -1,  1, -1,  3,
        3, -1, -1,  1,      1, -3, -1,  1,      1, -1, -3,  1,      1, -1, -1,  3,
        -3, -1, -1,  1,     -1, -3, -1,  1,     -1, -1, -3,  1,     -1, -1, -1,  3,
        3,  1,  1, -1,      1,  3,  1, -1,      1,  1,  3, -1,      1,  1,  1, -3,
        -3,  1,  1, -1,     -1,  3,  1, -1,     -1,  1,  3, -1,     -1,  1,  1, -3,
        3, -1,  1, -1,      1, -3,  1, -1,      1, -1,  3, -1,      1, -1,  1, -3,
        -3, -1,  1, -1,     -1, -3,  1, -1,     -1, -1,  3, -1,     -1, -1,  1, -3,
        3,  1, -1, -1,      1,  3, -1, -1,      1,  1, -3, -1,      1,  1, -1, -3,
        -3,  1, -1, -1,     -1,  3, -1, -1,     -1,  1, -3, -1,     -1,  1, -1, -3,
        3, -1, -1, -1,      1, -3, -1, -1,      1, -1, -3, -1,      1, -1, -1, -3,
        -3, -1, -1, -1,     -1, -3, -1, -1,     -1, -1, -3, -1,     -1, -1, -1, -3,
    ]
}
