
import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: Dot product

infix operator • : MultiplicationPrecedence

// MARK: Cross product

infix operator ⨯ : MultiplicationPrecedence

// MARK: Degrees to Radians

postfix operator °

public postfix func ° (value: Float) -> Float {
    return value * Float.pi / 180.0
}

public postfix func ° (value: Double) -> Double {
    return value * Double.pi / 180.0
}

#if canImport(CoreGraphics)
public postfix func ° (value: CGFloat) -> CGFloat {
    return value * CGFloat(Float.pi / 180.0)
}
#endif

public postfix func ° (value: Int) -> Double {
    return Double(value) * Double.pi / 180.0
}

// MARK: Percent

postfix operator %

public postfix func % (value: Float) -> Float {
    return value / 100.0
}

public postfix func % (value: Double) -> Double {
    return value / 100.0
}

#if canImport(CoreGraphics)
public postfix func % (value: CGFloat) -> CGFloat {
    return value / 100.0
}
#endif

public postfix func % (value: Int) -> Double {
    return Double(value) / 100.0
}
