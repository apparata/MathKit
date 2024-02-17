//
//  Copyright © 2022 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Quintic Ease-In

/// Quintic (power of 5) ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quinticEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    return t * t * t * t * t
}

// MARK: - Quintic Ease-Out

/// Quintic (power of 5) ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quinticEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let f = (t - 1)
    return f * f * f * f * f + 1
}

// MARK: - Quintic Ease-In-Ease-Out

/// Quintic (power of 5) ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quinticEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    if t < (1 / 2) {
        return 16 * t * t * t * t * t
    } else {
        let f = ((2 * t) - 2)
        let fQuint = f * f * f * f * f
        return fQuint * (1 / 2) + 1
    }
}
