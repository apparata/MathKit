//
//  Copyright © 2022 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Sine Ease-In

/// Trigonometric (sin) ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func sineEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    let t = Double(t)
    return T(sin((t - 1) * 0.5 * .pi) + 1)
}

// MARK: - Sine Ease-Out

/// Trigonometric (sin) ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func sineEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let t = Double(t)
    return T(sin(t * 0.5 * .pi))
}

// MARK: - Sine Ease-In-Ease-Out

/// Trigonometric (sin) ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func sineEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let t = Double(t)
    return T(0.5 * (1 - cos(t * .pi)))
}
