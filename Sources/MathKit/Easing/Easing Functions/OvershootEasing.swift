//
//  Copyright © 2024 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Overshoot Ease-In

/// Overshoot ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func overshootEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    let overshoot: T = 1.70158
    return t * t * ((overshoot + 1) * t - overshoot)
}

// MARK: - Overshoot Ease-Out

/// Overshoot ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func overshootEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let overshoot: T = 1.70158
    let t = t - 1
    return t * t * ((overshoot + 1) * t + overshoot) + 1
}

// MARK: - Overshoot Ease-In-Ease-Out

/// Overshoot ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func overshootEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let overshoot: T = 1.70158 * 1.525
    let t = t * 2
    if t < 1 {
        return (t * t * ((overshoot + 1) * t - overshoot)) / 2
    } else {
        let tPrime = t - 2
        return (tPrime * tPrime * ((overshoot + 1) * tPrime + overshoot)) / 2 + 1
    }
}
