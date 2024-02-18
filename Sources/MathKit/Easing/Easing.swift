import Foundation

/// Easing mode indicates whether an ease function should be applied to
/// the start of the interval, the end, or both, and also the function to use.
public enum EasingType {
    case linear
    case easeIn(EasingFunction)
    case easeOut(EasingFunction)
    case easeInOut(EasingFunction)
}

/// Easing type represents a certain type of easing function.
public enum EasingFunction {
    case quadratic
    case cubic
    case quartic
    case quintic
    case sine
    case overshoot
}

/// Represents a particular combination of an easing type and an easing function.
public class Easing {

    /// The easing type used in the calculation of this easing.
    public let type: EasingType

    /// Initializes the easing with a particular mode and a particular type.
    public init(_ type: EasingType) {
        self.type = type
    }

    /// Allows for the easing instance to be called as a function.
    ///
    /// - Parameter t: A progress parameter, typically in the closed range 0...1
    ///
    /// - Returns: The progress value with the easing function applied to it.
    ///
    public func callAsFunction<T: BinaryFloatingPoint>(_ t: T) -> T {
        switch type {
        case .linear: t
        case .easeIn(.quadratic): quadraticEaseIn(t)
        case .easeOut(.quadratic): quadraticEaseOut(t)
        case .easeInOut(.quadratic): quadraticEaseInOut(t)
        case .easeIn(.cubic): cubicEaseIn(t)
        case .easeOut(.cubic): cubicEaseOut(t)
        case .easeInOut(.cubic): cubicEaseInOut(t)
        case .easeIn(.quartic): quarticEaseIn(t)
        case .easeOut(.quartic): quarticEaseOut(t)
        case .easeInOut(.quartic): quarticEaseInOut(t)
        case .easeIn(.quintic): quinticEaseIn(t)
        case .easeOut(.quintic): quinticEaseOut(t)
        case .easeInOut(.quintic): quinticEaseInOut(t)
        case .easeIn(.sine): sineEaseIn(t)
        case .easeOut(.sine): sineEaseOut(t)
        case .easeInOut(.sine): sineEaseInOut(t)
        case .easeIn(.overshoot): overshootEaseIn(t)
        case .easeOut(.overshoot): overshootEaseOut(t)
        case .easeInOut(.overshoot): overshootEaseInOut(t)
        }
    }
}
